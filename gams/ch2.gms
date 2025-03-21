*==================================================
$title  第2章习题第二题
*==================================================
* 先设定集合
set ac     /sec1,sec2,sec3,labor,capital,finaluse,total/ ;
set i(ac)  /sec1,sec2,sec3/;
set z(ac)  /labor, capital/;
alias (i,j);

*=====================================================================
*将投入产出表的数据读入。
*用指令table宣称， 然后命名表格，如这里IO。括号里面包括行和列两个变量元素。注意对准每列的数据。没有数据的地方GAMS读成0。
*=====================================================================
table IO(*,*)
        sec1 sec2 sec3 finaluse total
sec1    160  150  90      480    880
sec2    140  320  170     900    1530
sec3    80   150  250     590    1070
labor   320  350  410  
capital 180  560  150
total   880 1530  1070
;

*======================================================================
$ontext
GAMS语言中的parameter(参数)，包括参数、常数、标量、和经济学上的外生变量。它们的特点，就是数值必须外生给定。
GAMS语言中的variable（变量），是系统内部计算出来的变量。也就是经济学上的内生变量。
对参数来说，先要声明或定义所用的参数和外生变量。以"parameter"宣称，然后每行列出一个参数。参数符号须用字母开头，后面可以跟字母或数字。如B,TA,Q3，等等。
每行开头是参数符号。 空几格后可以对参数做注释说明(虽然这注释说明是可选项，但是对以后理解程序有帮助)。
两维度的参数集，如下面int(i,j)所示，括号里面第一个元素（indexed set）为行，第二个元素为列。
初始值习惯上用"0"结尾，如下面的Q0。注意数字0和字母O的差别。
整段最后用分号结尾。
$offtext
*=======================================================================
parameter
int(i,j)       intermidiate input 中间投入数量
use(i)         finaluse 最终使用
vat(z,j)       value add total 增加值等于劳动报酬加资本
a(i,j)         direct input-output coefficients 投入产出直接消耗系数
Q0(i)          initial value for total output 总产出的初始值
;

*========================================================================
* 对参数赋值和定义 assignment for parameters
* calibration 校调(估算)参数值
* 每个等式后有分号。
* 对其它没有直接数值的参数校调估算。等号左面的参数数值由右面的已知参数数值决定。
* 右面参数数值必须在前面的程序指令中已给定或者被说明。
*========================================================================
int(i,j)=IO(i,j);
use(i) =IO(i,"finaluse");
vat(z,i) =IO(z,i);
Q0(i)=IO("total",i);
a(i,j)=int(i,j)/Q0(j);
*display 打印展示数值
display int,use,vat,q0,a;

*=====================================================
Display ' 以下为模拟部分 Simulation'
*=====================================================
*模拟 simulation
*模拟政策或其它外界变量变化后对模型(内生)变量的影响
*假设部门2的产量增加100
*=====================================================
parameter
use2(i)  changes in the finaluse
         /sec1   0
         sec2    200
         sec3    0 /  ;
         
variable
Q(i)      total output 总产出变量;

*=====================================================
*对模型等式取新名commodityequi2，并将新的数据写进
*对模拟的模型取新名，如IOmodelSim，表示模拟
*指令solve,运行和求解模型。指明这次求解的等式为
*=====================================================
equation
commodityequi2(i);

commodityequi2(i)..
sum(j,a(i,j)*Q(j))+use2(i)=e=Q(i);

model SimIOmodel /commodityequi2/
solve SimIOmodel using mcp;

*打印最后结果 result output。单引号里面的文字说明也会打印出来
display 'Q.l， 为求解的结果',    Q.l

*=====================================================
*结束 the end
*=====================================================



