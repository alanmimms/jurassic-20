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

const diagFuncTypes = `\
  STOP_CLOCK = 0o000,                           \
  START_CLOCK = 0o001,                          \
  STEP_CLOCK = 0o002,                           \
  COND_STEP = 0o004,                            \
  BURST = 0o005,                                \
                                                \
  CLR_RESET = 0o006,                            \
  SET_RESET = 0o007,                            \
  CLR_RUN = 0o010,                              \
  SET_RUN = 0o011,                              \
  CONTINUE = 0o012,                             \
                                                \
  CLR_BURST_CTR_RH = 0o042,                     \
  CLR_BURST_CTR_LH = 0o043,                     \
  CLR_CLK_SRC_RATE = 0o044,                     \
  SET_EBOX_CLK_DISABLES = 0o045,                \
  RESET_PAR_REGS = 0o046,                       \
  CLR_MBOXDIS_PARCHK_ERRSTOP = 0o047,           \
                                                \
  CLR_CRAM_DIAG_ADR_RH = 0o051,                 \
  CLR_CRAM_DIAG_ADR_LH = 0o052,                 \
                                                \
  ENABLE_KL = 0o067,                            \
                                                \
  INIT_CHANNELS = 0o070,                        \
  WRITE_MBOX = 0o071,                           \
  EBUS_LOAD = 0o076,                            \
                                                \
  Idle = 0o077`

      .trim()
      .split(/,\s*/)
      .reduce((cur, t) => {
        const [name, value] = t.split(/\s*=\s*/);
        return Object.assign(cur, {[`diagf${name}`]: +value});
      }, {});


const [, , hFileName, svhFileName] = process.argv.slice(1);
console.log(`hFileName=${hFileName}, svhFileName=${svhFileName}`);

const hFileContent = `
${defCXXEnum('tReqType', FEreqTypes)};

${defCXXNames('reqTypeNames', FEreqTypes)};


${defCXXEnum('tMiscFuncType', miscFuncTypes)};

${defCXXNames('miscFuncNames', miscFuncTypes)};


${defCXXSparseEnum('tDiagFunction', diagFuncTypes, 7)};

${defCXXSparseNames('diagFuncNames', diagFuncTypes)};
`;
fs.writeFileSync(hFileName, hFileContent);


const svhFileContent = `
\`ifndef __DTE_SVH__
\`define __DTE_SVH__ 1
${defCXXEnum('tReqType', FEreqTypes)};

${defCXXEnum('tMiscFuncType', miscFuncTypes)};

${defSVHSparseEnum('tDiagFunction', diagFuncTypes, 'bit [0:6]', 7)};
\`endif
`;
fs.writeFileSync(svhFileName, svhFileContent);


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
