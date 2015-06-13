# coding: utf-8

from util import file_as_list

def read_template_file(template_file_name):
    content = file_as_list(template_file_name)
    def get_key(line):
        return line.split(' ')[2]
    def get_name(line):
        return line.split(' ')[3]
    def get_new_name(line):
        return line.split(' ')[7]
    def get_note(line):
        return line.split(' ')[4]
    def get_pos(line):
        return line.split(' ')[0]

    def printer_process(line):
        name = get_name(line)
        note = get_note(line)
        key = get_key(line)
        pos = get_pos(line)
        
        # Имя по новой базе данных
        oid_name = get_new_name(line)
        return name, key, int(pos), note, oid_name
     
    cash_file = []
    for record in content:
        oid, key, pos, note, oid_name = printer_process(record)
        if oid:
            cash_file.append((oid, key, pos, note, oid_name))
    return cash_file 

def read_template_file_update(template_file_name):
    content = file_as_list(template_file_name)

    def get_key(line):
        return line.split(' ')[0]
    def get_oid(line):
        return line.split(' ')[1]
    def get_descripton(line):
        return line.split(' ')[2]

    def printer_process(line):
        key = get_key(line)
        oid = get_oid(line)
        note = get_descripton(line)

        return [key], oid, note
     
    cash_file = []
    for record in content:
        key, oid, note = printer_process(record)
        if oid:
            cash_file.append((key, oid, note))
    return cash_file 

def read_template_file_multypatch(template_file_name):
    content = file_as_list(template_file_name)

    def get_keys(line):
        line_local = line.split(']')[0][1:].replace('u\'', '').replace('\',', '').replace('\'','')
        return line_local.split(' ')
    def get_oid(line):
        line_local = line.split(']')[1].lstrip().rstrip()
        return line_local.split(' ')[0]
    def get_descripton(line):
        line_local = line.split(']')[1].lstrip().rstrip()
        return line_local.split(' ')[1]

    def printer_process(line):
        key = get_keys(line)
        oid = get_oid(line)
        note = get_descripton(line)

        return key, oid, note
     
    cash_file = []
    for record in content:
        key, oid, note = printer_process(record)
        if oid:
            cash_file.append((key, oid, note))
    return cash_file 