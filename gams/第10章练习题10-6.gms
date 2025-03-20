$title  第10章练习题10.6，设置价格基准，仅在商品市场1等式中加入WALRAS虚变量

$ontext
设置价格基准，仅在商品市场1等式中加入WALRAS虚变量
因此要在商品部门中再定义两个子集，市场1的子集agr和其它部门的子集Nagr
用凯恩斯宏观闭合：劳动力和资本要素供应内生决定，居民总需求金额YH外生决定
因为劳动力供应内生决定，需求本来就不等于禀赋，因此不宜在本等式中加入WALRAS
固定劳动力价格和GDP价格指数，其中一个可以认作价格基准
$offtext

set ac   /agri,manu,serv,lab,cap,hh,total/;
set a(ac)  /agri,manu,serv/;
set f(ac)  /lab,cap/;
set agr(a) "农业部门的子集" /agri/ ;
set Nagr(a) "除了农业之外的所有商品部门";
Nagr(a)=YES; Nagr('agri')=NO;

alias (ac,acp),(a,ap),(agr,agrp),(nagr,nagrp),(f,fp);

table sam(ac,acp)
        agri   manu   serv  lab   cap   hh     total
agri    260    320    150               635    1365
manu    345    390    390               600    1725
serv    400    365    320               385    1470
lab     200    250    400                       850
cap     160    400    210                       770
hh                          850   770          1620
total   1365   1725   1470  850   770   1620
;

parameter  rhoq(a)    /agri =   0.2,   manu = 0.3,  serv = 0.1 /
           rhoVA(a)   /agri     0.25,  manu   0.5,  serv   0.8 /
           LESelas(a) /agri     0.5,   manu   1.0,  serv   1.2 /;

display agr,nagr;

*定义参数
parameters

scaleAq(a)       QA的CES函数参数
deltaq(a)        QA的CES函数（增值部份）份额参数
scaleAVA(a)      VA的CES函数参数
deltaVA(a)       VA的CES函数（劳动部份）份额参数
ia(a,ap)         中间投入的投入产出系数
PA0(a)           商品a的价格
QA0(a)           商品a的数量
PVA0(a)          增值部分汇总价格
QVA0(a)          增值部分汇总量
PINTA0(a)        中间投入总价格
QINTA0(a)        中间投入总量
QINT0(a,ap)      中间投入个量
QLD0(a)          劳动需求
QKD0(a)          资本需求
QLS0             劳动量供应
QKS0             资本量供应
WL0              劳动价格
WK0              资本价格
gdpwt(a)         计算GDP价格指数用的权重
PGDP0            基准年度的GDP价格指数
YH0              居民收入
QH0(a)           居民对商品a的需求
bgtshr(a)        LES函数中消费预算商品a的份额
bgtshrchk        LES函数中消费预算商品a的份额参数检验
LESbeta(a)       LES边际消费额， �@
LESbetachk       LES边际消费额参数和检验
LESsub(a)        LES消费函数基本生存消费量
frisch           弗里希参数
;

*参数（包括外生变量）赋值与精校

Frisch=-2;
PA0(a)=1;
PVA0(a)=1;
PINTA0(a)=1;
WK0=1;
WL0=1;
QA0(a)=sam('total',a)/PA0(a);
QVA0(a)=SUM(f,sam(f,a));
QINT0(a,ap)=sam(a,ap)/PA0(a);
QINTA0(a)=SUM(ap,QINT0(ap,a));
ia(a,ap)=QINT0(a,ap)/QINTA0(ap);
QLS0=sum(a,sam('lab',a))/WL0;
QKS0=sum(a,sam('cap',a))/WK0;
QLD0(a)=sam('lab',a)/WL0;
QKD0(a)=sam('cap',a)/WK0;
deltaq(a)=PVA0(a)*QVA0(a)**(1-rhoq(a))/(PVA0(a)*QVA0(a)**(1-rhoq(a))+PINTA0(a)*QINTA0(a)**(1-rhoq(a)));
scaleAq(a)=QA0(a)/(deltaq(a)*QVA0(a)**rhoq(a)+(1-deltaq(a))*QINTA0(a)**rhoq(a))**(1/rhoq(a));
deltaVA(a)=WL0*QLD0(a)**(1-rhoVA(a))/(WL0*QLD0(a)**(1-rhoVA(a))+WK0*QKD0(a)**(1-rhoVA(a)));
scaleAVA(a)=QVA0(a)/(deltaVA(a)*QLD0(a)**rhoVA(a)+(1-deltaVA(a))*QKD0(a)**rhoVA(a))**(1/rhoVA(a));
YH0=WL0*QLS0+WK0*QKS0;
QH0(a)=SAM(a,'hh')/PA0(a);
gdpwt(a)=QH0(a)/sum(ap,QH0(ap));
PGDP0=sum(a,PA0(a)*gdpwt(a));
*下面是LES函数模块
bgtshr(a)=SAM(a,'hh')/YH0;
bgtshrchk=sum(a,bgtshr(a));
LESbeta(a)=LESelas(a)*bgtshr(a)/(sum(ap,LESelas(ap)*bgtshr(ap)));
LESbetachk=sum(a,LESbeta(a));
LESsub(a)=sam(a,'hh')+(LESbeta(a)/PA0(a))*(YH0/frisch);

display PA0,PVA0,PINTA0,QA0,QVA0,QINTA0,QINT0,rhoq,rhoVA,scaleAq,deltaq,scaleAVA,deltaVA,ia,frisch,QLD0,QKD0,QLS0,QKS0,WL0,WK0,YH0,QH0,gdpwt,bgtshrchk,LESbetachk,LESsub;

variable

PA(a),PVA(a),PINTA(a),WL,WK,QA(a),QVA(a),QINTA(a),QINT(a,ap),QLD(a),QKD(a),QLS,QKS,YH,QH(a),PGDP,
*瓦尔拉斯法则，这里用加一个虚变量walras的方法
walras
;

*定义等式
equation

QAfn(a),QAFOCeq(a),PAeq(a),QVAfn(a),QVAFOC(a),PVAeq(a),QINTfn(a,ap),PINTAeq(ap),
YHeq,QHeq(a),ComEquiAmkt(agr),ComEquiNAmkt(a),Leq,Keq,PGDPeq
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
WL/WK=e=(deltaVA(a)/(1-deltaVA(a)))*(QKD(a)/QLD(a))**(1-rhoVA(a));

PVAeq(a)..
PVA(a)*QVA(a)=e=WL*QLD(a)+WK*QKD(a);

QINTfn(a,ap)..
QINT(a,ap)=e=ia(a,ap)*QINTA(ap);

PINTAeq(ap)..
PINTA(ap)=e=SUM(a,ia(a,ap)*PA(a));

YHeq..
YH=e=WL*QLS+WK*QKS;

QHeq(a)..
PA(a)*QH(a)=e=PA(a)*LESsub(a)+LESbeta(a)*(YH-sum(ap,PA(ap)*LESsub(ap)));

*瓦尔拉斯法则，这里在农业部门市场系统均衡等式上加一个虚变量walras的方法
ComEquiAmkt(agr)..
QA(agr)=e=sum(ap,QINT(agr,ap))+QH(agr)+walras;

ComEquiNAmkt(nagr)..
QA(nagr)=e=sum(ap,QINT(nagr,ap))+QH(nagr);

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
YH.l=YH0;
QH.l(a)=QH0(a);
QLS.l=QLS0;
QKS.l=QKS0;
WK.l=1;
walras.l=0;

*凯恩斯闭合条件
WL.fx=1;
PGDP.fx=PGDP0;
YH.fx=YH0;

*执行优化程序
model cgeKeynes  /all/;
solve cgeKeynes using mcp;
*检验walras是否等于零
display walras.l,QLS.l,QKS.l;

*检验凯恩斯模型的乘数
YH.fx=YH0*1.2;
model checkKeynesYHup  /all/;
solve checkKEYnesYHup using mcp;
*检验walras是否等于零
display walras.l,QLS.l,QKS.l;

*End
