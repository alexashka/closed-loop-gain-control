# coding: utf-8

if __name__=='__main__':
    table_name = 'FRW'
    root = 'Root'
    branch = 'Branch'
    records = 'None'
    template = 'sys'+table_name+'Table  OBJECT-TYPE\r\n'+\
    '    SYNTAX SEQUENCE OF Sys'+table_name+'TableEntry\r\n'+\
    '    MAX-ACCESS not-accessible\r\n'+\
    '    STATUS     current\r\n'+\
    '    DESCRIPTION \r\n'+\
    '        ""\r\n'+\
    '    ::= { '+root+' '+branch+' }\r\n'+\
    '\r\n'+\
    'sys'+table_name+'TableEntry  OBJECT-TYPE\r\n'+\
    '    SYNTAX     Sys'+table_name+'TableEntry\r\n'+\
    '    MAX-ACCESS not-accessible\r\n'+\
    '    STATUS     current\r\n'+\
    '    DESCRIPTION \r\n'+\
    '        ""\r\n'+\
    '    INDEX { sys'+table_name+'Idx }\r\n'+\
    '    ::= { sys'+table_name+'Table 1 }\r\n'+\
    '    \r\n'+\
    'sys'+table_name+'Idx  OBJECT-TYPE\r\n'+\
    '    SYNTAX     Integer32\r\n'+\
    '    MAX-ACCESS read-write\r\n'+\
    '    STATUS     current\r\n'+\
    '    DESCRIPTION \r\n'+\
    '        ""\r\n'+\
    '    ::= { sys'+table_name+'TableEntry 1 }\r\n'+\
    '\r\n'+\
    'Sys'+table_name+'TableEntry ::= SEQUENCE {\r\n'+\
    '    sys'+table_name+'Idx\r\n'+\
    '        Integer32,\r\n'+\
    '    '+records+'\r\n'+\
    '}'
    
    print template
