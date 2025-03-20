$title 例12.5.1 包括私人和公共储蓄的凯恩斯闭合的CGE模型

*采用GDP价格指数作为价格基准
*加上并测试投资－储蓄公式

*定义集合所有账户 ac和生产活动a
set ac      /agri,manu,serv,lab,cap,hh,ent,gov,vatl,vatk,invsav,total/;
set a(ac)   /agri,manu,serv/;
set f(ac)   /lab,cap/;
set vat(ac) /vatl,vatk/;

alias (ac,acp),(a,ap),(f,fp),(vat,vatp);

table sam(ac,acp)
        agri   manu   serv  lab   cap   hh    ent  gov   vatl  vatk  invsav  total
agri    260    320    150               500        71                 155    1456
manu    345    390    390               450        65                 150    1790
serv    400    365    320               350        48                 48     1531
lab     200    250    400                                                     850
cap     210    400    210                                                     820
hh                          850   770              17                        1637
ent                                50              40                          90
gov                                     162   40          85    82            369
vatl    20      25     40                                                      85
vatk    21      40     21                                                      82
invsav                                  175   50   128                        353
total   1456   1790   1531  850   820   1637  90   369    85    82     353
;

*下面3行为SAM表外给定的参数数值
parameter  rhoq(a)    /agri =   0.2,   manu = 0.3,  serv = 0.1 /
           rhoVA(a)   /agri     0.25,  manu   0.5,  serv   0.8 /
           LESelas(a) /agri     0.5,   manu   1.0,  serv   1.2 /
           Frisch     /-2/;

*定义参数
parameters

scaleAq(a)       QA的CES函数参数
deltaq(a)        QA的CES函数份额参数
scaleAVA(a)      VA的CES函数参数
deltaVA(a)       VA的CES函数劳动份额参数
ia(a,ap)         中间投入的投入产出系数
shrg(a)          政府收入中对商品a的消费支出
tih              居民所得税税率
tiEnt            企业所得税税率
tval(a)          对劳动投入的增值税率
tvak(a)          对资本投入的增值税率
transfrHG0       政府对居民的转移收入
transfrEntG0     政府对企业的转移收入
shifhk           资本收入分配给居民的份额
shifentk         资本收入分配给企业的份额
mpc              边际消费倾向（这里也是平均消费倾向）
bgtshr(a)        LES函数中消费预算商品a的份额
bgtshrchk        LES函数中消费预算商品a的份额参数检验
LESbeta(a)       LES边际消费额， �@
LESbetachk       LES边际消费额参数和检验
LESsub(a)        LES消费函数基本生存消费量

PA0(a)           商品a的价格
QA0(a)           商品a的数量
PVA0(a)          增值部分(含增值税）汇总价格
QVA0(a)          增值部分汇总量
PINTA0(a)        中间投入总价格
QINTA0(a)        中间投入总量
QINT0(a,ap)      中间投入个量
QLD0(a)          劳动需求
QKD0(a)          资本需求
WL0              劳动价格
WK0              资本价格
QLS0             劳动量供应
QKS0             资本量供应
YH0              居民收入
EH0              居民消费总额
QH0(a)           居民对商品a的需求
YENT0            企业收入
EINV0            投资总额
QINV0(a)         对商品a的投资的最终需求
ENTSAV0          企业储蓄
YG0              政府收入
EG0              政府支出
QG0(a)           政府对商品a的需求
GSAV0            政府储蓄
gdpwt(a)         计算GDP价格指数用的权重
PGDP0            基准年度的GDP价格指数
;

*参数（包括外生变量）赋值与校调
PA0(a)=1;
PINTA0(a)=1;
WK0=1;
WL0=1;
PGDP0=1;
tval(a)=sam('vatl',a)/sam('lab',a);
tvak(a)=sam('vatk',a)/sam('cap',a);
QLD0(a)=sam('lab',a)/WL0;
QKD0(a)=sam('cap',a)/WK0;
QVA0(a)=SUM(f,Sam(f,a));
*以下增值汇总价格包含了增值税部分
PVA0(a)=((1+tval(a))*WL0*QLD0(a)+(1+tvak(a))*WK0*QKD0(a))/QVA0(a);
QA0(a)=sam('total',a)/PA0(a);
QINT0(a,ap)=sam(a,ap)/PA0(a);
QINTA0(a)=SUM(ap,QINT0(ap,a));
ia(a,ap)=QINT0(a,ap)/QINTA0(ap);
QLS0=sum(a,sam('lab',a))/WL0;
QKS0=sum(a,sam('cap',a))/WK0;
deltaq(a)=PVA0(a)*QVA0(a)**(1-rhoq(a))/(PVA0(a)*QVA0(a)**(1-rhoq(a))+PINTA0(a)*QINTA0(a)**(1-rhoq(a)));
scaleAq(a)=QA0(a)/(deltaq(a)*QVA0(a)**rhoq(a)+(1-deltaq(a))*QINTA0(a)**rhoq(a))**(1/rhoq(a));
deltaVA(a)=((1+tval(a))*WL0)*QLD0(a)**(1-rhoVA(a))/(((1+tval(a))*WL0)*QLD0(a)**(1-rhoVA(a))+((1+tvak(a))*WK0)*QKD0(a)**(1-rhoVA(a)));
scaleAVA(a)=QVA0(a)/(deltaVA(a)*QLD0(a)**rhoVA(a)+(1-deltaVA(a))*QKD0(a)**rhoVA(a))**(1/rhoVA(a));
transfrhg0=sam('hh','gov');
transfrEntG0=sam('ent','gov');
shifhk=sam('hh','cap')/(sam('hh','cap')+sam('ent','cap'));
YH0=WL0*QLS0+shifhk*WK0*QKS0+transfrhg0;
tih=sam('gov','hh')/YH0;
mpc=sum(a,sam(a,'hh'))/((1-tih)*YH0);
EH0=mpc*(1-tih)*YH0;
QH0(a)=SAM(a,'hh')/PA0(a);
bgtshr(a)=SAM(a,'hh')/EH0;
bgtshrchk=sum(a,bgtshr(a));
*Below is the LES function block, the LES marginal share coefficient is scaled to satisfy the constraint.
LESbeta(a)=LESelas(a)*bgtshr(a)/(sum(ap,LESelas(ap)*bgtshr(ap)));
LESbetachk=sum(a,LESbeta(a));
LESsub(a)=sam(a,'hh')+(LESbeta(a)/PA0(a))*(EH0/frisch);
shifentk=sam('ent','cap')/(sam('hh','cap')+sam('ent','cap'));
YENT0=shifentk*WK0*QKS0+transfrEntG0;
QINV0(a)=sam(a,'invsav')/PA0(a);
EINV0=sum(a,QINV0(a)*PA0(a));
tiEnt=sam('gov','ent')/YEnt0;
ENTSAV0=(1-tiEnt)*YENT0;
YG0=tih*YH0+tiEnt*YENT0+sam('gov','vatl')+sam('gov','vatk');
GSAV0=sam('invsav','gov');
EG0=YG0-GSAV0;
QG0(a)=sam(a,'gov')/PA0(a);
shrg(a)=PA0(a)*QG0(a)/(EG0-transfrhg0-transfrEntG0);
gdpwt(a)=(QH0(a)+QINV0(a)+QG0(a))/sum(ap,(QH0(ap)+QINV0(ap)+QG0(ap)));
PGDP0=sum(a,PA0(a)*gdpwt(a));

display LESbeta,LESsub,LESelas,rhoq,rhoVA,bgtshrchk,LESbetachk,PA0,WK0,WL0,QA0,
         QLD0,QKD0,QLS0,QKS0,QH0,transfrhg0,YH0,tih,tient,shifhk,shifentk,YG0,QG0,shrg,tval,tvak,gdpwt,PGDP0;

variable
PA(a),PVA(a),PINTA(a),WL,WK,QA(a),QVA(a),QINTA(a),QINT(a,ap),QLD(a),QKD(a),QLS,QKS,YH,EH,QH(a),YENT,EINV,ENTSAV,YG,EG,QG(a),GSAV,PGDP
;

*下面对等式定义
equation

QAfn(a)
QAFOCeq(a)
PAeq(a)
QVAfn(a)
QVAFOC(a)
PVAeq(a)
QINTfn(a,ap)
PINTAeq(ap)
YHeq
EHeq
QHeq(a)
YENTeq
EINVeq
ENTSAVeq
YGeq
QGeq(a)
EGeq
ComEqui(a)
Leq
Keq
PGDPeq
;

QAfn(a)..
QA(a)=e=scaleAq(a)*(deltaq(a)*QVA(a)**rhoq(a)+(1-deltaq(a))*QINTA(a)**rhoq(a))**(1/rhoq(a));

QAFOCeq(a)..
PVA(a)/PINTA(a)=e=(deltaq(a)/(1-deltaq(a)))*(QINTA(a)/QVA(a))**(1-rhoq(a));

PAeq(a)..
PA(a)*QA(a)=e=PVA(a)*QVA(a)+PINTA(a)*QINTA(a);

QVAfn(a)..
QVA(a)=e=scaleAVA(a)*(deltaVA(a)*QLD(a)**rhoVA(a)+(1-deltaVA(a))*QKD(a)**rhoVA(a))**(1/rhoVA(a));

QVAFOC(a)..
((1+tval(a))*WL)/((1+tvak(a))*WK)=e=(deltaVA(a)/(1-deltaVA(a)))*(QKD(a)/QLD(a))**(1-rhoVA(a));

PVAeq(a)..
PVA(a)*QVA(a)=e=(1+tval(a))*WL*QLD(a)+(1+tvak(a))*WK*QKD(a);

QINTfn(a,ap)..
QINT(a,ap)=e=ia(a,ap)*QINTA(ap);

PINTAeq(ap)..
PINTA(ap)=e=SUM(a,ia(a,ap)*PA(a));

YHeq..
YH=e=WL*QLS+shifhk*WK*QKS+transfrhg0;

EHeq..
EH=e=mpc*(1-tih)*YH;

QHeq(a)..
PA(a)*QH(a)=e=PA(a)*LESsub(a)+LESbeta(a)*(EH-sum(ap,PA(ap)*LESsub(ap)));
YENTeq..
YENT=e=shifentk*WK*QKS+transfrentg0;

EINVeq..
EINV=e=sum(a,PA(a)*QINV0(a));

ENTSAVeq..
ENTSAV=e=(1-tiEnt)*YENT;

YGeq..
YG=e=sum(a,tval(a)*WL*QLD(a))+sum(a,tvak(a)*WK*QKD(a))+tih*YH+tiEnt*YENT;

EGeq..
EG=e=YG-GSAV;

QGeq(a)..
PA(a)*QG(a)=e=shrg(a)*(EG-transfrhg0-transfrEntg0);

ComEqui(a)..
QA(a)=e=sum(ap,QINT(a,ap))+QH(a)+QINV0(a)+QG(a);

Leq..
Sum(a,QLD(a))=e=QLS;

Keq..
Sum(a,QKD(a))=e=QKS;

PGDPeq..
PGDP=e=sum(a,PA(a)*gdpwt(a));


*赋予变量的初始值

PA.l(a)=PA0(a);
PVA.l(a)=PVA0(a);
PINTA.l(a)=PINTA0(a);
QA.l(a)=QA0(a);
QVA.l(a)=QVA0(a);
QINTA.l(a)=QINTA0(a);
QINT.l(a,ap)=QINT0(a,ap);
QLD.l(a)=QLD0(a);
QKD.l(a)=QKD0(a);
QLS.l=QLS0;
QKS.l=QKS0;
YH.l=YH0;
EH.l=EH0;
QH.l(a)=QH0(a);
YENT.l=YENT0;
EINV.l=EINV0;
ENTSAV.l=ENTSAV0;
YG.l=YG0;
QG.l(a)=QG0(a);
QLS.l=QLS0;
QKS.l=QKS0;
PGDP.l=PGDP0;

*凯恩斯宏观闭合限制条件
WL.fx=1;
WK.fx=1;
EG.fx=EG0;

*执行优化程序
model cge  /all/;
solve cge using mcp;

*下面加上投资－储蓄等式(12.5.22)包括虚变量walras，证明投资－储蓄等式是线性相关的。
variable
WALRAS;
equations
ISeq;
ISeq..
EINV=e=(1-mpc)*(1-tih)*YH+ENTSAV+GSAV+WALRAS;
model cgewithIS /all/;
solve cgewithIS using mcp;
display WALRAS.l;

*下面模拟政府增加支出的冲击结果及乘数
parameters
GDP0;
GDP0=sum(a,(QH0(a)+QINV0(a)+QG0(a)));
EG.fx=EG0+1;
variable
GDP;
equations
GDPeq;
GDPeq..
GDP=e=sum(a,(QH(a)+QINV0(a)+QG(a)));
*执行优化程序
model sim1  /all/;
solve sim1 using mcp;

Parameter
Multiplier government expenditure multiplier;
Multiplier=(GDP.l-GDP0)/1;
display  GDP0,GDP.l,Multiplier;

*下面模拟增值税转型冲击的结果及税收乘数
tvak(a)=0;
EG.fx=EG0;
*执行优化程序
model sim2  /all/;
solve sim2 using mcp;

Parameter
TaxMultiplier tax change impact;
TaxMultiplier=GDP.l/GDP0;
display  tvak,EG.l,GDP0,GDP.l,TaxMultiplier;

*end



