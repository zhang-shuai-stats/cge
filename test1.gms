variable
x;

*=====================================================
*对模型等式取新名commodityequi2，并将新的数据写进
*对模拟的模型取新名，如IOmodelSim，表示模拟
*指令solve,运行和求解模型。指明这次求解的等式为
*=====================================================
equation
f;

f..
x**2 - 3*x + 1 =e=0;

x.l=1

model SimIOmodel /f/
solve SimIOmodel using mcp;

*打印最后结果 result output。单引号里面的文字说明也会打印出来
display 'x， 为求解的结果',    x.l