function ws2wav(dat, fname)
  dat = dat/max(abs(dat));
  wavwrite(dat, fname);
