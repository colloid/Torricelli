Program Sq1;

Var 
    A, B, C, D, X1, X2 : Real;

Begin
  Writeln ('Введите коэффициенты квадратного уравнения');
  Readln (A,B,C);
  D := B*B - 4*A*C;
     If D<0 Then Writeln ('Корней нет! ')
     Else
     Begin
           X1:=(-B+SQRT(D))/2/A;
           X2:=(-B-SQRT(D))/2/A;
           Writeln ('X1=', X1, ' X2=',X2)
       End;
End.
