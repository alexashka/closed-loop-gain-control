% Abstract: переворачивает вектор
%           !длина задана извне

function q = bitroute(iQ, iLen)
  % первый байт младший(обратный порядок следования байт)
  for i = 1:iLen
    q(i) = iQ(iLen-i+1); end