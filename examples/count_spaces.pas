program CountSpacesInString;
var
  str: string;

function CountSpaces (s: string): integer;
var
   i, count: integer;
begin
  count := 0;
  for i:=1 to length(s) do
    if s[i]=' ' then
      count := count+1;
  CountSpaces := count;
end;

{основная программа}
begin
    writeln('Программа подсчитывает количество пробелов '
            +'во введенной строке');
    repeat
       writeln('Введите исходную непустую строку:');
       readln(str);
         if (length(str)<1) then
            writeln('Исходная строка должна быть непустой');
    until length(str)>0;
    writeln('В строке "',str,'" ',CountSpaces(str),' пробелов.');

end.

