$title  例8.4.1 有CES生产函数的基本CGE模型

*定义集合 ac意为账户account  集合c为商品

set ac   /sec1,sec2,lab,cap,hh,total/
    c(ac)  /sec1,sec2/
;

*给ac别名
alias (ac,acp);

*读取SAM表的数值
table sam(ac,acp)
        sec1   sec2   lab   cap   hh    total
sec1                              12    12
sec2                              21    21
lab      9      7                       16
cap      3      14                      17
hh                     16    17         33
total    12     21     16    17   33
;

*定义参数
parameters

Q0(c)                商品c的数量
P0(c)                商品c的价格
LD0(c)                劳动需求
KD0(c)                资本需求
LS0                劳动量供应
KS0                资本量供应
WL0                劳动价格
WK0                资本价格
Y0                居民收入
QH0(c)                居民对商品i的需求
scaleA(c)        CES函数规模因素参数 可以从SAM表中求出
delta(c)        CES函数份额参数 可以从SAM表中求出
rho(c)                CES函数幂参数 外生给定 假设从替代弹性导出后等于0.6
alphah(c)        居民收入中对商品i的消费支出 可以从SAM表中求出
;

*下面为参数（包括外生变量）赋值或校调估值calibrate
rho(c)=0.6;
P0(c) =1;
WL0=1;
WK0=1;
Q0(c) = sam('total',c)/P0(c);
LD0(c)=sam('lab',c)/WL0;
KD0(c)=sam('cap',c)/WK0;
LS0=sum(c,LD0(c));
KS0=sum(c,KD0(c));
Y0=WL0*LS0+WK0*KS0;
QH0(c) =SAM(c,'hh')/P0(c);

*校调生产函数参数
delta(c)=WL0*LD0(c)**(1-rho(c))/( WL0*LD0(c)**(1-rho(c))+WK0*KD0(c)**(1-rho(c)));
scaleA(c)=Q0(c)/(delta(c)*LD0(c)**rho(c)+(1-delta(c))*KD0(c)**rho(c))**(1/rho(c));

*校调Cobb-Douglas效用函数导出的消费需求
alphah(c)=P0(c)*QH0(c)/Y0;

*展现参数的值和校调值
display  rho,delta,scaleA,Q0,LD0,KD0,LS0,KS0,Y0,QH0;

*定义变量
variable
P(c) ,WK,WL,Q(c),LD(c),KD(c),Y,QH(c),LS,KS;
*上面LS和KS也作为变量，这是因为考虑到以后在模拟中要改变其数值研究政策冲击的变化。在后面"宏观闭合"部分，这两个变量数值被指令.fx固定住了，所以它们的实际功能是参数或外生变量。

*定义等式。注意等式数量和上面的内生变量数目要一致，不然解法MCP会停止执行。
equation

Qeq(c),FOCeq(c),PRICEeq(c),IncomeYeq,QHeq(c),Qbal(c),Leq,Keq
;

Qeq(c)..
Q(c)=e=scaleA(c)*(delta(c)*LD(c)**rho(c)+(1-delta(c))*KD(c)**rho(c))**(1/rho(c));

FOCeq(c)..
WL/WK=e=delta(c)/(1-delta(c))*(KD(c)/LD(c))**(1-rho(c));

PRICEeq(c)..
WL*LD(c)+WK*KD(c)=e=P(c)*Q(c);

IncomeYeq..
WL*LS+WK*KS=e=Y;

QHeq(c)..
P(c)*QH(c)=e=alphah(c)*Y;

Qbal(c)..
QH(c)=e=Q(c);

Leq..
Sum(c,LD(c))=e=LS;

Keq..
Sum(c,KD(c))=e=KS;


*赋予变量的初始值
P.l(c)=P0(c);
WL.l=WL0;
WK.l=WK0;
Q.l(c)= Q0(c);
LD.l(c)= LD0(c);
KD.l(c)=KD0(c);
LS.l=LS0;
KS.l=KS0;

*宏观闭合：全部要素充分就业.外生变量用.fx
LS.fx=LS0;
KS.fx=KS0;

*执行优化程序
model cge  /all/;
solve cge using mcp;

*Replication 复制检验
WL.l=1.1;
model replic /all/;
solve replic using mcp;
display P.l, WL.l, WK.l, Q.l, LD.l, KD.l,LS.l, KS.l;


*Simulation 模拟
*假如劳动供应和劳动要素禀赋增加10%,求结果
WL.l=1;
LS.fx=1.1*LS0;
model sim /all/;
solve sim using mcp;
display P.l, WL.l, WK.l, Q.l, LD.l, KD.l,LS.l, KS.l

*end 程序结束
