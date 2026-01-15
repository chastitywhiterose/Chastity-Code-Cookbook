# Design of chaste-256 CPU

This document is an attempt for me to plan the design of a new type of CPU. This must be done first and I need to fully plan the design of this virtual CPU before I can write an Assembler or Interpreter for such a system.

In fact, this entire project may totally fail, but that doesn't mean I can't try. I will talk about some key points of the motivation and goals for this.

## Why another CPU? Aren't there enough?

Yes there are plenty of current and historical processors. Some of them were real hardware in the past and are emulated now. Some of them are popular, such as Intel 8086 descendants being the dominant and various ARM chips becoming more popular for movile devices or low power consumption laptops.

However, the existing CPUs in current use are not simple because they contain just about every type of addressing mode and different models containing different register sizes and instructions. There is also the problem of the CPUs and their associated instruction sets being proprietary and owned by specific companies. I want something that is original and that I designed, which is incredibly hard to do in this world full of billions of people who have done everything imaginable.

Of the existing CPU types, I have read the most good about RISC-V. I even have written some basic Assembly Language programs using a simulator. However, I still want to create my own that is even simpler.

## What type of instruction set and data types will it support?

Historical 8-bit CPUs such as the 6502 or Z80 had the advantage of supporting less memory and having fewer registers. These limitations are a benefit rather than a detriment because the goal is to push the limits of how small and basic a processor can be. Considering this, I know that my first CPU will be based on 8 bits accessed at a time and I have chosen the name chaste-256 for this reason because 256 is the total number of possible numbers a single byte can contain. Everything from 00000000 to 11111111 in binary.

But still, some questions remain. How many registers will it have? Or perhaps the better question is what is a register and does it need to have them at all? A register is a named variable that is accessed separately from the rest of the RAM. In some cases, arithmetic is only performed on registers and these registers are loaded and stored between memory addresses, and, if it is present, the "stack", which is a concept that deserves its own chapter.

As for the instruction set, I have determined that 16 or fewer instruction types must exist. The following list gives their current names and description of what they do. However, these names may change if I have a good reason.

| Name         | Description |
|--------------| ----------- |
| load         | Load Register with Number or Memory|
| save         | Load Register to Memory or ??????? |
| add          | Add numbers between Registers      |
| sub          | Subtract numbers between Registers |
| mul          | Multiply numbers between Registers |
| div          | Divide numbers between Registers   |
| temp          |    d  |
| and          | Divide numbers between Registers   |
| or          | Divide numbers between Registers   |
| xor          | Divide numbers between Registers   |
