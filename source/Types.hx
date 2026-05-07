package;

/**
 * -128 to 127
**/
typedef ByteInt = #if cpp cpp.Int8 #else Int #end;
/**
 * 0 to 255
**/
typedef ByteUInt = #if cpp cpp.UInt8 #else Int #end;
/**
 * -32768 to 32767
**/
typedef ShortInt = #if cpp cpp.Int16 #else Int #end;
/**
 * 0 to 65535
**/
typedef ShortUInt = #if cpp cpp.UInt16 #else Int #end;


typedef NoteInt = ByteInt;