def cyclic(arg1):
  rangelist = range(arg1)
  print rangelist
  out = range(arg1)  # ���� �������������
  for number in rangelist:
    out[number] = number*number
  # output
  return out
