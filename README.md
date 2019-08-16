This is totally a playground work in progress.

The idea here is to take the DECSYSTEM-20 KL10PV CPU schematics and
create a logical description of the entire system's netlists so I can
build a JavaScript based emulation of the logic. This would then allow
me to run the DECSYSTEM-20 microcode.

When that's "running", I want to use it as a logical description of
the KL10PV and use _that_ to generate a JavaScript emulation of the
CPU's behavior. I also considered the possibility of generating C or
LLVM code to do the emulation.

This mapping of hardware and microcode to emulation flow is intriguing
to me. I know it's a huge project. It's a hobby. I don't really have a
reason for doing it other than that I like the idea. And as a hobby, I
expect it to entertain me for years.

We'll see.

