$title  例5.2.1   Least square balance method 最小二乘法平衡SAM表

*定义集合 i
set i  /sec1,sec2,lab,hh/;
alias  (i,j);

*=========== SAM表 ===============
table SAM(*,*)
        sec1   sec2   lab   hh    total
sec1    52     45           150   247
sec2    95     48           90    233
lab     120    89                 209
hh                    192         192
total   267    182    192   240
;

parameters
Q0(i,j)        initial value;

*Assignment for parameters
Q0(i,j)=sam(i,j);

*定义变量与函数
variables
Q(i,j) 要调整的SAM表中的各个数值
z  目标函数的数值 即平方差之和;

*每个变量必须是非负数
positive variable Q(i,j);

equations
sumsquare        目标函数 即平方差之和的等式
balance          各个账户的平衡限制条件 ;

*在GAMS程序中，"$"符号是条件指令，意为"在…的条件情况下该程式有效"。它放置在程式第一个定义之后。条件指令$(SAM(i,j)意为：在SAM表上i,j位置格上的数值不等于0的情况下执行该指令。
*sqr 为计算平方的指令。
*注：如果将sqr(Q(i,j)改成(Q(i,j)**2，虽然数学和语法上也是正确的，可是用PATH的MCP解算, 结果不是最优。这是当前PATH需要改进的地方。
sumsquare..
z =e= sum((i,j)$sam(i,j),sqr(Q(i,j)-sam(i,j)));

*注意下面等式的写法。第一是等式balance(i)，表示有i=1,..n个等式
*第二，注意sum记号里面Q(j,i）的位置变换，等号左面是行汇总，等号右边是列汇总
balance(i)..
sum(j$sam(i,j),Q(i,j)) =e= sum(j$sam(j,i),Q(j,i));

*对变量初始值赋值
Q.l(i,j)=Q0(i,j);

model sambal  /all/;
solve sambal using nlp minimizing z;

*打印结果
display Q.l,z.l;

*end 结束
