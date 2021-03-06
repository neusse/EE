//*****************************************************************************
// Filename : 'font5x5p.h'
// Title    : Graphic lcd 5x5 proportional font (ascii characters)
//*****************************************************************************

#ifndef FONT5X5P_H
#define FONT5X5P_H

//
// An ascii 5x5 proportional bitmap font.
// Defines ascii characters 0x20-0x7f (32-127), excluding lowercase a..z.
//
// A character requires between 1 and 5 bytes. The first byte is the width of
// the character, 3 bits wide, merged with the first font byte, 5 bits wide.
// Any subsequent bytes are the remaining bitmaps for the character.
// The bitmap bytes move from left to right and the LSB defines the 'top dot'.
//
// Example for char 'R':
// Data: (0x03 << 5) | 0x1f, 0x05, 0x1a,
// => Width : 0x03
// => Bitmap: 0x1f, 0x05, 0x1a
//
// 0x01 - # # .
// 0x02 - # . #
// 0x04 - # # .
// 0x08 - # . #
// 0x10 - # . #
//
// Note: To preserve precious flash space, the lowercase characters are
// omitted as they are identical to their uppercase version. When using a
// lowercase character the user must manually remap it to its uppercase
// version. Characters that are located after the lowercase set are shifted
// since the lowercase characters do not exist.
// Also, since characters have a variable width we will need a font index array
// that points to the proper font start byte in the actual font array.
//
// See code example below that defines a proper offset in the font index array,
// returning the entry point in the font array for the character. It will get
// the width of the character, as derived from the first font byte, as well as
// the first fontbyte bitmap itself.
//
// char c;
// u08 idxOffset, width, fontByte;
// if (c >= 'a' && c <= 'z')
//   idxOffset = 0x20;
// else if (c > 'z')
//   idxOffset = 26;
// else
//   idxOffset = 0;
// idxOffset = pgm_read_byte(&Font5x5pIdx[c - 0x20 - idxOffset])
// width = pgm_read_byte(&Font5x5p[idxOffset]) >> 5;
// fontByte = (pgm_read_byte(&Font5x5p[idxOffset]) & 0x1f);
//

// Define the 5x5 proportional character bitmaps
static const uint8_t __attribute__ ((progmem)) Font5x5p[] =
{
  (0x01 << 5) |	0x00,				// (space)
  (0x01 << 5) | 0x17,				// !
  (0x03 << 5) | 0x03, 0x00, 0x03,		// "
  (0x05 << 5) | 0x0a, 0x1f, 0x0a, 0x1f, 0x0a,	// #
  (0x05 << 5) | 0x02, 0x15, 0x1f, 0x15, 0x08,	// $
  (0x03 << 5) | 0x19, 0x04, 0x13,		// %
  (0x04 << 5) | 0x0a, 0x15, 0x12, 0x08,		// &
  (0x01 << 5) | 0x03,				// '
  (0x02 << 5) | 0x0e, 0x11,			// (
  (0x02 << 5) | 0x11, 0x0e,			// )
  (0x03 << 5) | 0x0a, 0x04, 0x0a,		// *
  (0x03 << 5) | 0x04, 0x0e, 0x04,		// +
  (0x02 << 5) | 0x10, 0x08,			// ,
  (0x03 << 5) | 0x04, 0x04, 0x04,		// -
  (0x01 << 5) | 0x10,				// .
  (0x03 << 5) | 0x18, 0x04, 0x03,		// /
  (0x03 << 5) | 0x1f, 0x11, 0x1f,		// 0
  (0x03 << 5) | 0x12, 0x1f, 0x10,		// 1
  (0x03 << 5) | 0x1d, 0x15, 0x17,		// 2
  (0x03 << 5) | 0x15, 0x15, 0x1f,		// 3
  (0x03 << 5) | 0x07, 0x04, 0x1f,		// 4
  (0x03 << 5) | 0x17, 0x15, 0x1d,		// 5
  (0x03 << 5) | 0x1f, 0x15, 0x1d,		// 6
  (0x03 << 5) | 0x01, 0x1d, 0x03,		// 7
  (0x03 << 5) | 0x1f, 0x15, 0x1f,		// 8
  (0x03 << 5) | 0x17, 0x15, 0x1f,		// 9
  (0x01 << 5) | 0x0a,				// :
  (0x02 << 5) | 0x10, 0x0a,			// ;
  (0x02 << 5) | 0x04, 0x0a,			// <
  (0x03 << 5) | 0x0a, 0x0a, 0x0a,		// =
  (0x02 << 5) | 0x0a, 0x04,			// >
  (0x03 << 5) | 0x01, 0x15, 0x02,		// ?
  (0x04 << 5) | 0x08, 0x15, 0x19, 0x0e,		// @
  (0x03 << 5) | 0x1e, 0x05, 0x1e,		// A
  (0x03 << 5) | 0x1f, 0x15, 0x0a,		// B
  (0x03 << 5) | 0x0e, 0x11, 0x11,		// C
  (0x03 << 5) | 0x1f, 0x11, 0x0e,		// D
  (0x02 << 5) | 0x1f, 0x15,			// E
  (0x02 << 5) | 0x1f, 0x05,			// F
  (0x03 << 5) | 0x0e, 0x11, 0x1d,		// G
  (0x03 << 5) | 0x1f, 0x04, 0x1f,		// H
  (0x01 << 5) | 0x1f,				// I
  (0x02 << 5) | 0x10, 0x0f,			// J
  (0x03 << 5) | 0x1f, 0x04, 0x1b,		// K
  (0x02 << 5) | 0x1f, 0x10,			// L
  (0x05 << 5) | 0x1f, 0x02, 0x04, 0x02, 0x1f,	// M
  (0x04 << 5) | 0x1f, 0x02, 0x04, 0x1f,		// N
  (0x03 << 5) | 0x0e, 0x11, 0x0e,		// O
  (0x03 << 5) | 0x1f, 0x05, 0x02,		// P
  (0x04 << 5) | 0x0e, 0x11, 0x09, 0x16,		// Q
  (0x03 << 5) | 0x1f, 0x05, 0x1a,		// R
  (0x03 << 5) | 0x12, 0x15, 0x09,		// S
  (0x03 << 5) | 0x01, 0x1f, 0x01,		// T
  (0x03 << 5) | 0x1f, 0x10, 0x1f,		// U
  (0x03 << 5) | 0x0f, 0x10, 0x0f,		// V
  (0x05 << 5) | 0x0f, 0x10, 0x0c, 0x10, 0x0f,	// W
  (0x03 << 5) | 0x1b, 0x04, 0x1b,		// X
  (0x03 << 5) | 0x03, 0x1c, 0x03,		// Y
  (0x03 << 5) | 0x19, 0x15, 0x13,		// Z
  (0x02 << 5) | 0x1f, 0x11,			// [
  (0x03 << 5) | 0x03, 0x04, 0x18,		// "\"
  (0x02 << 5) | 0x11, 0x1f,			// ]
  (0x03 << 5) | 0x02, 0x01, 0x02,		// ^
  (0x03 << 5) | 0x10, 0x10, 0x10,		// _
  (0x02 << 5) | 0x01, 0x02,			// `
  // Gap for non-existing a-z lowercase characters
  (0x03 << 5) | 0x04, 0x1f, 0x11,		// {
  (0x01 << 5) | 0x1f,				// |
  (0x03 << 5) | 0x11, 0x1f, 0x04,		// }
  (0x04 << 5) | 0x04, 0x15, 0x0e, 0x04,		// ->
  (0x04 << 5) | 0x04, 0x0e, 0x15, 0x04		// <-
};

// Define for each character its entry point index in the 5x5 proportional
// character bitmap array
static const uint8_t __attribute__ ((progmem)) Font5x5pIdx[] =
{
    0,   1,   2,   5,  10,  15,  18,  22,  23,  25,  27,  30,  33,  35,  38,
   39,  42,  45,  48,  51,  54,  57,  60,  63,  66,  69,  72,  73,  75,  77,
   80,  82,  85,  89,  92,  95,  98, 101, 103, 105, 108, 111, 112, 114, 117,
  119, 124, 128, 131, 134, 138, 141, 144, 147, 150, 153, 158, 161, 164, 167,
  169, 172, 174, 177, 180, 182, 185, 186, 189, 193
};
#endif
