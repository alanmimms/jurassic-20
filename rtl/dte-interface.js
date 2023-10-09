// Create the dte.svh and dte.h interface files to span between
// SystemVerilog and C++ without drift. To use this file, use gcc -E
// to expand macros with either GENERATE_CXX defined to make the C++
// version or GENERATE_SVH to make the SystemVerilog version of the
// definitions.

const fs = require('fs');

const FEreqTypes = `None,DiagFunc,Read,Write,Misc,ReleaseEBUSData`
      .split(/,\s*/)
      .map(t => `dte${t}`);

const miscFuncTypes = `clrCROBAR,getAPRID,writeMemory,readMemory,getDiagWord1,loadAR,resetCRA`
      .split(/,\s*/)
      .map(t => t);

// These come from `docs/EK-OKL10-MG-003_KL10_Maintenance_Guide_Volume_1_Rev_3_Apr85_text.pdf`
// PDF71-73.
const diagFuncTypes = `
  STOP_CLOCK = 0o00,
  START_CLOCK = 0o01,
  STEP_CLOCK = 0o02,
  STEP_EBUS_CLOCK = 0o03,
  COND_STEP = 0o04,
  BURST = 0o05,
  CLR_RESET = 0o06,
  SET_RESET = 0o07,

  CLR_RUN = 0o10,
  SET_RUN = 0o11,
  CONTINUE = 0o12,

  IRLTCH = 0o14,
  DRLTCH = 0o15,

  BURST_CTR_RH = 0o42,
  BURST_CTR_LH = 0o43,
  CLK_SRC_RATE = 0o44,
  SET_EBOX_CLK_DISABLES = 0o45,
  RESET_PAR_REGS = 0o46,
  MBOXDIS_PARCHK_ERRSTOP = 0o47,

  CRAM_DIAG_ADR_RH = 0o51,
  CRAM_DIAG_ADR_LH = 0o52,
  CRAM_WRITE_80_85 = 0o53,
  CRAM_WRITE_60_79 = 0o54,
  CRAM_WRITE_40_59 = 0o55,
  CRAM_WRITE_20_39 = 0o56,
  CRAM_WRITE_00_19 = 0o57,

  LDRAM1 = 0o60,
  LDRAM2 = 0o61,
  LDRAM3 = 0o62,
  LDRJEV = 0o63,
  LDRJOD = 0o64,
  DISIOJ = 0o65,
  DISACF = 0o66,
  ENABLE_KL = 0o67,

  INIT_CHANNELS = 0o70,
  WRITE_MBOX = 0o71,
  SET_KW20_CLOCK = 0o72,

  MEM_RESET = 0o76,
  LOAD_AR = 0o77,

  CRAM_READ_00_19 = 0o147,
  CRAM_READ_20_39 = 0o146,
  CRAM_READ_40_59 = 0o145,
  CRAM_READ_60_79 = 0o144,
  CRAM_READ_80_85 = 0o141
`.trim()
 .split(/,\s*/)
 .reduce((cur, t) => {
   const [name, value] = t.split(/\s*=\s*/);
   return Object.assign(cur, {[`diagf${name}`]: +value});
 }, {});


const [, , hFileName, svhFileName, tffName] = process.argv.slice(1);
console.log(`hFileName=${hFileName}, svhFileName=${svhFileName} tffName=${tffName}`);

const hContent = `
${defCXXEnum('tReqType', FEreqTypes)};

${defCXXNames('reqTypeNames', FEreqTypes)};


${defCXXEnum('tMiscFuncType', miscFuncTypes)};

${defCXXNames('miscFuncNames', miscFuncTypes)};


${defCXXSparseEnum('tDiagFunction', diagFuncTypes, 7)};

${defCXXSparseNames('diagFuncNames', diagFuncTypes)};
`;
fs.writeFileSync(hFileName, hContent);


const svhContent = `
\`ifndef __DTE_SVH__
\`define __DTE_SVH__ 1
${defCXXEnum('tReqType', FEreqTypes)};

${defCXXEnum('tMiscFuncType', miscFuncTypes)};

${defSVHSparseEnum('tDiagFunction', diagFuncTypes, 'bit [0:6]', 7)};
\`endif
`;
fs.writeFileSync(svhFileName, svhContent);


const tffContent = `\
${Object.entries(diagFuncTypes)
    .map(([k, v]) => `\
${v.toString(8).padStart(3, '0')} ${k.replace('diagf', '').toLowerCase()}`)
    .join('\n')}
`;
fs.writeFileSync(tffName, tffContent);


function defCXXEnum(enumName, items) {
  return `\
typedef enum {
  ${items.join(',\n  ')}
} ${enumName}`;
}


function defCXXNames(arrayName, items) {
  return `\
static const char *${arrayName}[] = {
  ${items.map(item => '"' + item + '"').join(',\n  ')}
}`;
}


function defCXXSparseEnum(enumName, items, w) {
  const nDigits = Math.ceil(w / 3) + 1; // +1 to assure leading zero to make it octal
  return `\
typedef enum {
  ${Object.keys(items).map(it => it + ' = ' +
     (+items[it]).toString(8).padStart(nDigits, '0')).join(',\n  ')}
} ${enumName}`;
}


function defCXXSparseNames(arrayName, items) {
  const inverted = invert(items);
  const values = Object.keys(inverted);
  const max = Math.max(...values);
  const nDigits = Math.ceil(Math.log2(max) / 3) + 1; // +1 for leading zero for octal
  const notSparse = [];

  for (let k = 0; k <= max; ++k) notSparse[k] = inverted[k];

  return `\
static const char *${arrayName}[] = {
  ` +
    notSparse.map((name, x) => {
      const oct = x.toString(8).padStart(nDigits, '0');
      return `\
  /* ${oct} */ "${inverted[x] || '???diagf' + oct + '???'}"`;
    }).join(',\n  ')
  + `
}`;
}


function defSVHSparseEnum(enumName, items, typedef, w) {
  const nDigits = Math.ceil(w / 3);
  return `\
typedef enum ${typedef} {
  ${Object.keys(items).map(it => it + " = " +
     w.toString() + "'o" + (+items[it]).toString(8).padStart(nDigits, '0')).join(',\n  ')}
} ${enumName}`;
}


function invert(items) {
  return Object.entries(items)
    .reduce((cur, [name, value]) => Object.assign(cur, {[+value]: name}),
            {});
}
