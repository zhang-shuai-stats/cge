$title  例6.6.1 一个最简单的CGE模型

*定义集合 ac意为账户account  i集合为商品, x集合为要素
set ac   /sec1,sec2,lab,hh,total/
    i(ac)  /sec1,sec2/
;

*给i取别名
alias (ac,acp), (i,ip);

*读取SAM表的数值
table sam(ac,acp)
        sec1   sec2   lab   hh    total
sec1     4      3           3      10
sec2     2      5           6      13
lab      4      5                   9
hh                     9            9
total   10     13      9    9
;

*定义参数
parameters
a(i,ip)              中间投入的投入产出系数（直接消耗系数）
ax(i)                要素投入产出系数
q0(i)                商品i的初始数量
p0(i)                商品i的初始价格
x0(i)                劳动初始需求
xe0                  劳动要素禀赋和供应
w0                   劳动初始价格
Y0                   居民初始收入金额
h0(i)                居民对商品i的初始数量需求
alpha(i)             居民收入中使用在商品i的份额，即等式6.6.19里的alpha
;

*下面为参数（包括外生变量）赋值或校调估值calibrate。
*注意从SAM表数值获取实际数量时，要除以价格
p0(i) =1;
w0=1;
q0(i) = sam('total',i)/p0(i);
x0(i)=sam('lab',i)/w0;
xe0=sam('lab','total')/w0;
Y0=w0*xe0;
h0(i)=SAM(i,'hh')/p0(i);

*校调估算投入产出系数
a(i,ip)=(sam(i,ip)/p0(i))/(sam('total',ip)/p0(ip));
ax(ip)=(sam('lab',ip)/w0)/(sam('total',ip)/p0(ip));

*校调Cobb-Douglas效用函数导出的在商品i上的消费需求份额
alpha(i)=p0(i)*h0(i)/Y0;

*展现参数的值和校调值,检验是否正确
display  a,ax,q0,x0,xe0,Y0,h0;

*定义变量
variable
p(i),q(i),x(i),h(i),Y,w;

*定义等式
equation
Priceeq(i),factoreq(i),IncomeYeq,Hdemand(i),Qmarket(i),Xmarket;

*下面等式里sum的功能，等于数学上sigma的相加。该等式对应课本中等式6.6.14和6.6.15
Priceeq(i)..
p(i)=e=sum(ip, p(ip)*a(ip,i))+w*ax(i);

Factoreq(i)..
ax(i)*q(i)=e=x(i);

IncomeYeq..
Y=e=w*xe0;

Hdemand(i)..
p(i)*h(i)=e=alpha(i)*Y;

Qmarket(i)..
sum(ip,a(i,ip)*q(ip))+h(i)=e=q(i);

Xmarket..
sum(i,x(i))=e=xe0;

*赋予变量的初始值
p.l(i)=p0(i);
q.l(i)=q0(i);
x.l(i)=x0(i);
h.l(i)=h0(i);
Y.l=Y0;
w.l=w0;

*执行优化程序
model cge  /all/;
solve cge using mcp;
display p.l,q.l,x.l,h.l,Y.l,w.l;

* 假设要素供给增加10%
xe0=1.1*sam('lab','total')/w0;
model cge1  /all/;
solve cge1 using mcp;
display p.l,q.l,x.l,h.l,Y.l,w.l;

*end 程序结束
