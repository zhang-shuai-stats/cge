$title  第五章练习题

*定义集合 i
set i  /sec1,sec2,sec3,lab,cap,hh/;
alias  (i,j);

*=========== SAM表 ===============
table SAM(*,*)
        sec1   sec2   sec3  lab   cap   hh     total  tartot
sec1    160    150    90                540    940    920
sec2    140    320    170               910    1540   1540
sec3    80     150    250               610    1090   2000 
lab     320    360    400                      1080   2000
cap     170    550    150                      870    900
hh                          1050   860                2900      
total   870    1530   1060  1050   860  2060
tartot  920    1540   2000  2000   900  2900
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
display '第一题结果', Q.l,z.l;

***********************
* 2.假设居民支出数据不能动
***********************
variables
Q1(i,j)
z1;

positive variable Q1(i,j);

equations
sumsquare1        
balance1;        

sumsquare1..
z1 =e= sum((i,j)$sam(i,j),sqr(Q1(i,j)-sam(i,j)));

balance1(i)..
sum(j$sam(i,j),Q1(i,j)) =e= sum(j$sam(j,i),Q1(j,i));

*对变量初始值赋值
Q1.l(i,j)=Q0(i,j);
Q1.fx(i,"hh") = Q0(i,"hh")
model sambal1  /sumsquare1, balance1/;
solve sambal1 using nlp minimizing z1;

*打印结果
display '第二题结果', Q1.l,z1.l;

***********************
* 4.RAS法平衡
***********************
Parameter
rowdis(i)
condis(j)
maxdis
iter;

maxdis = 0.1;
iter = 1;

while (iter<5000 and maxdis>1e-12,
sam("total",j) = sum(i,sam(i,j));
sam(i,j) = sam(i,j)/sam("total",j)*sam("tartot",j);

sam(i,"total") = sum(j,sam(i,j));
sam(i,j) = sam(i,j)/sam(i,"total")*sam(i,"tartot");

condis(j) = abs(sum(i,sam(i,j))-sam("tartot",j));
rowdis(i) = abs(sum(j,sam(i,j))-sam(i,"tartot"));

maxdis = max{smax{j,condis(j)},smax{i,rowdis(i)}};
iter=iter+1;
);

display '第四题结果',   sam;

***********************
* 5.直接交叉熵平衡
***********************
Parameter
H0;

H0 = sum((i,j),Q0(i,j));

display H0;

Variables
Q2(i,j)
H
Hratio
z2;

Positive Variable Q2(i,j), H, Hratio;

Equations
Hequ
Hratioequ
obj
balance2;

Hequ..
H =e= sum((i,j)$Q0(i,j),Q(i,j));

Hratioequ..
Hratio =e= H/H0;

balance2(i)..
sum(j$Q0(i,j),Q2(i,j)) =e= sum(j$Q0(j,i),Q2(j,i));

obj..
z2 =e= sum((i,j)$Q0(i,j),(1/H)*Q(i,j)*log(Q(i,j)/Q0(i,j))) - log(Hratio);

Q2.l(i,j)=Q0(i,j);
H.l = H0;
Hratio.lo = 0.5;
Hratio.up = 2;

model sambal2  /Hequ,Hratioequ,balance2,obj/;
solve sambal2 using nlp minimizing z2;

*打印结果
display '第五题结果', Q2.l,z2.l, Hratio.l;












*end 结束
