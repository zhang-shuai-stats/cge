$title  第3章例3.5.1 投入产出价格模型

*对集合说明和定义。在集合名称右边的中文是为了方便的文字说明，不是GAMS指令。可以省略。

set ac     总集        /sec1,sec2,sec3,labor,capital,consumption,investment,total/;
set i(ac)  商品部门集  /sec1,sec2,sec3/;
set x(ac)  要素集      /labor,capital/;
set s(ac)  为了模拟部门2价格变化问题建立的子集  /sec1,sec3/;

alias (i,j);
alias (s,ss);

*将投入产出表的数据全部读入。
table IO(*,*)
        sec1    sec2    sec3    consumption  investment  Total
sec1    200     300     150     280          70          1000
sec2    80      400     250     550          320         1600
sec3    30      420     240     350          110         1150
labor   500     250     330
capital 190     230     180
Total   1000    1600    1150
;

parameter

realq(i,j)  real quantities of the IO table after deflating price 除掉价格后的真实产量
realf(x,j)  real quantities of factor 除掉要素价格后的真实要素投入量
q0(i)       initial value for real total output 真实总产出的初始值
a(i,j)      direct input-output coefficients 投入产出直接消耗系数
b(x,j)      factor-input-output coefficients  要素消耗系数
p0(i)       initial price of commodities        初始商品价格
w0(x)       initial price of factors     初始要素价格
con(i)      consumption 居民消费
inv(i)      investment 投资
lab(j)      labor input 劳动投入
cap(j)      capital input 资本投入
;


*对参数赋值并校调(估算)参数  (calibration)

$ontext
注意以下的等式中包含了价格起始变量p0和w0，这是因为价值型投入产出模型中的数值为价值的缘故。将价值型投入产出表中的价值数字除以价格后获取真实产量和真实要素投入量
再从真实数量中获取投入产出系数， 虽然因为起始价格为1，在下列等式中省略价格起始变量并不影响数字结果，但是概念上有错误。这个概念在以后从SAM表上建立CGE模型很重要。
$offtext

p0(i)=1;
w0(x)=1;
realq(i,j)=IO(i,j)/p0(i);
realf(x,j)=IO(x,j)/w0(x);
q0(i)=IO("total",i)/p0(i);
a(i,j)=realq(i,j)/q0(j);
b(x,j)=realf(x,j)/q0(j);
con(i)=IO(i,"consumption")/p0(i);
inv(i)=IO(i,"investment")/p0(i);
lab(j)=IO("labor",j)/w0("labor");
cap(j)=IO("capital",j)/w0("capital");

*说明和定义内生变量 variable

variable
p(i)            price of commodities
w(x)            price of factors
q(i)            total output 总产出变量
;

display realq,realf,Q0,a,b,p0,w0,con,inv,lab,cap;

*说明函数并对此赋值  declare equation
equation
priceequ(j);

priceequ(j)..
sum(i,a(i,j)*p(i))+sum(x,b(x,j)*w(x))=e=p(j);

*赋予内生变量初始值
p.l(i)=p0(i);
w.fx(x)=w0(x);

*说明模型并指令运行
model IOPricemodel  /all/;
solve IOPricemodel using mcp
;

*结果显示
display p.l,  w.l;

*=========================
*模拟：工资增加20％
*=========================

*建立新参数。说明并赋值
parameter
wl1         labor price
wk1         capital cost
;

wl1=1.2;
wk1=1;

display wl1, wk1;


*说明并定义新函数
equation
Sim1priceequ(j);

Sim1priceequ(j)..
sum(i,a(i,j)*p(i))+b("capital",j)*wk1+b("labor",j)*wl1=e=p(j);

*赋予内生变量初始值
p.l(i)=p0(i);

*指令模型运行
model SimPricemodel  /Sim1priceequ/;
solve SimPricemodel using mcp
;

*从解出的数值求增值
parameter
Pincrease(j)   increase in price in various sectors
;

Pincrease(j)=p.l(j)-1

*结果显示
display p.l,  Pincrease;

*================================
*模拟：商品2价格增加10％
*================================
*注意：在这个情况下，模型的结构有变化，只有两个等式，即，为商品1和商品3的价格等式，因此用子集s
*建立新参数。说明并赋值

parameter
p20(s)       price of sec1 and sec3
p2fx(ss)     price of sector 2
a2(s,ss)     direct input-output coefficients for sec1 and sec3
a22(ss)      direct input-output coefficients for sec2
b2(x,ss)     factor-input-output coefficients for sec1 and sec3
;

p20(s)=1;
p2fx(ss)=1.1;
a2(s,ss)=IO(s,ss)/IO("total",ss);
a22(ss)=IO("sec2",ss)/IO("total",ss);
b2(x,ss)=IO(x,ss)/IO("total",ss);

display a2, b2, p2fx, a22;

variable
p2(s);

equation
Sim2priceequ(ss);

Sim2priceequ(ss)..
sum(s,a2(s,ss)*p2(s))+a22(ss)*p2fx(ss)+sum(x,b2(x,ss)*w(x))=e=p2(ss);

p2.l(s)=p20(s);

model Sim2Pricemodel  /Sim2priceequ/;
solve Sim2Pricemodel using mcp
;

parameter
Pincrease2(ss)   increase in price in various sectors
;

Pincrease2(ss)=p2.l(ss)-1

*结果显示
display p2.l,  Pincrease2;

*结束 the end
