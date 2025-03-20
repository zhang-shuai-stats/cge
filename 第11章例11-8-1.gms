$title  例11.8.1 新古典主义闭合的有政府和税收的CGE模型，计算资本供应量变化冲击与乘数

*定义集合所有账户 ac和生产活动a
set ac   /sec1,sec2,lab,cap,gov,hh,vatl,vatk,total/;
set a(ac)  /sec1,sec2/;

alias (ac,acp);

* 读取SAM表的数值
table sam(ac,acp)
        sec1   sec2   lab   cap   hh    gov   vatl vatk total
sec1                              150   29.3            179.3
sec2                              190   30              220
lab     110    70                                       180
cap      53    130                                      183
hh                    180   183         11              374
gov                               34          18   18.3 70.3
vatl    11     7                                        18
vatk    5.3    13                                       18.3
total   179.3  220    180   183   374   70.3  18   18.3

*定义参数
parameters

PA0(a)           商品a的价格
WK0              资本价格
WL0              劳动价格
QA0(a)           商品a的数量
QLD0(a)          劳动需求
QKD0(a)          资本需求
QLS0             劳动量供应
QKS0             资本量供应
QH0(a)           居民对商品a的需求
YH0              居民收入
EG0              政府支出
YG0              政府收入
QG0(a)           政府对商品a的需求
rho(a)           CES函数参数 外生给定 假设等于0.6
delta(a)         CES函数参数 可以从SAM表中求出
scaleA(a)        CES函数参数 可以从SAM表中求出
shrh(a)          居民收入中对商品a的消费支出 可以从SAM表中求出
shrg(a)          政府收入中对商品a的消费支出 可以从SAM表中求出
tih              居民所得税税率可以从SAM表中求出
tval(a)          对劳动投入的增值税率
tvak(a)          对资本投入的增值税率
transfrhg0       政府对居民的转移收入
PGDP0            国民生产总值价格指数
GDP0             国民生产总值
;

*赋值并校调估算参数（包括外生变量）
PA0(a)=1;
WK0=1;
WL0=1;
QA0(a)=sam('total',a)/PA0(a);
QLD0(a)=(sam('lab',a))/WL0;
QKD0(a)=sam('cap',a)/wk0;
QLS0=sum(a,sam('lab',a))/WL0;
QKS0=sum(a,sam('cap',a))/WK0;
QH0(a) =SAM(a,'hh')/PA0(a);
transfrhg0=sam('hh','gov');
YH0=WL0*QLS0+WK0*QKS0+transfrhg0;
tih=sam('gov','hh')/YH0;
YG0=tih*YH0+sam('gov','vatl')+sam('gov','vatk');
EG0=YG0;
QG0(a) =SAM(a,'GOV')/PA0(a);
rho(a)=0.6;
delta(a)=WL0*QLD0(a)**(1-rho(a))/(WL0*QLD0(a)**(1-rho(a))+WK0*QKD0(a)**(1-rho(a)));
scaleA(a)=QA0(a)/(delta(a)*QLD0(a)**rho(a)+(1-delta(a))*QKD0(a)**rho(a))**(1/rho(a));
shrh(a)=PA0(a)*QH0(a)/((1-tih)*YH0);
shrg(a)=PA0(a)*QG0(a)/(YG0-transfrhg0);
tval(a)=sam('vatl',a)/sam('lab',a);
tvak(a)=sam('vatk',a)/sam('cap',a);
PGDP0=1;
GDP0=sum(a,PA0(a)*sam(a,'hh')+PA0(a)*sam(a,'gov'))/PGDP0;

display PA0,WK0,WL0,QA0,PGDP0,QLD0,QKD0,QLS0,QKS0,QH0,transfrhg0,YH0,tih,YG0,QG0,shrh,shrg,tval,tvak,GDP0;

*变量（内生变量）定义
variable
QA(a),QLD(a),QKD(a),YH,QH(a),QG(a),YG,EG,GDP,PA(a),WL,WK
*下面3个内生变量将要变为外生变量，因为后面程序语言将它们加上固定数值的后缀 .fx
QLS,QKS,PGDP
;

*下面对等式定义
*因为加了PGDP为价格基准，减少了1个内生变量，相应地去除商品1的市场供求均衡等式,仅流行商品1的供求平衡等式ComEqui2
equation
QAeq(a),FOCQAeq(a),PAeq(a),YHeq,QHeq(a),YGeq,QGeq(a),EGeq,ComEqui2,Leq,Keq,GDPeq,PGDPeq
;

QAeq(a)..
QA(a)=e=scaleA(a)*(delta(a)*QLD(a)**rho(a)+(1-delta(a))*QKD(a)**rho(a))**(1/rho(a));

FOCQAeq(a)..
((1+tval(a))*WL)/((1+tvak(a))*WK)=e=delta(a)/(1-delta(a))*(QKD(a)/QLD(a))**(1-rho(a));

PAeq(a)..
PA(a)*QA(a)=e=(1+tval(a))*WL*QLD(a)+(1+tvak(a))*WK*QKD(a);

YHeq..
YH=e=WL*QLS+WK*QKS+transfrhg0;

QHeq(a)..
PA(a)*QH(a)=e=shrh(a)*YH*(1-tih);

YGeq..
YG=e=tih*YH+sum(a,tval(a)*WL*QLD(a))+sum(a,tvak(a)*WK*QKD(a));

QGeq(a)..
PA(a)*QG(a)=e=shrg(a)*(EG-transfrhg0);

EGeq..
YG=e=EG;

ComEqui2..
QA('sec2')=e=QH('sec2')+QG('sec2');

Leq..
Sum(a,QLD(a))=e=QLS;

Keq..
Sum(a,QKD(a))=e=QKS;

GDPeq..
GDP=e=sum(a,QH(a)+QG(a));

PGDPeq..
PGDP*GDP=e=sum(a,PA(a)*(QH(a)+QG(a)));


*赋予变量的初始值
QA.l(a)=QA0(a);
QLD.l(a)=QLD0(a);
QKD.l(a)=QKD0(a);
YH.l=YH0;
QH.l(a)=QH0(a);
QG.l(a)=QG0(a);
YG.l=YG0;
EG.l=EG0;
GDP.l=GDP0;
PA.l(a)=PA0(a);
WL.l=WL0;
WK.l=WK0;
QLS.fx=QLS0;
QKS.fx=QKS0;
PGDP.fx=PGDP0;

*执行优化程序
model cge  /all/;
solve cge using mcp;

display PA.l,WK.l,WL.l,QA.l,QLD.l,QKD.l,QLS.l,QKS.l,QH.l,transfrhg0,
         YH.l,tih,YG.l,EG.l,QG.l,shrh,shrg,tval,tvak,PGDP0,GDP.l;

*下面模拟资本要素变动政策
QKS.fx=QKS0+1;

parameter
GDPold  储存政策变动以前的GDP数值;
GDPold=GDP.l;

model sim1  /all/;
solve sim1 using mcp;

display PA.l,WK.l,WL.l,QA.l,QLD.l,QKD.l,QLS.l,QKS.l,QH.l,transfrhg0,
         YH.l,tih,YG.l,EG.l,QG.l,shrh,shrg,tval,tvak,PGDP0,GDP.l;

Parameter
Multiplier  资本供应乘数;
Multiplier=(GDP.l-GDPold)/1;

display  Multiplier;

*End
