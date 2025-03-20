$title  例8.7.1 有CES嵌套函数的CGE模型

*定义集合所有账户 ac，生产活动a和要素f
*农业：agri;  制造业:manu;  服务业:serve;
set ac   /agri,manu,serv,lab,cap,hh,total/;
set a(ac)  /agri,manu,serv/;
set f(ac)  /lab,cap/;

alias (ac,acp),(a,ap),(f,fp);

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

*下面2行为SAM表外给定的参数数值
parameter  rhoq(a)    /agri =   0.2,   manu = 0.3,  serv = 0.1 /
           rhoVA(a)   /agri     0.25,  manu   0.5,  serv   0.8 /

*定义参数
parameters

scaleAq(a)       QA的CES函数参数
deltaq(a)        QA的CES函数份额参数
scaleAVA(a)      VA的CES函数参数
deltaVA(a)       VA的CES函数劳动份额参数
ia(a,ap)         中间投入的投入产出系数
shrh(a)          居民收入中对商品a的消费支出
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
YH0              居民收入
QH0(a)           居民对商品a的需求
;

*参数（包括外生变量）赋值与校调

PA0(a)=1;
PVA0(a)=1;
PINTA0(a)=1;
WK0=1;
WL0=1;
QA0(a)=sam('total',a)/PA0(a);
QVA0(a)=SUM(f,Sam(f,a));
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
shrh(a)=(PA0(a)*QH0(a))/sum(ap,sam(ap,'hh'));

*"display"的目的是检验所读的参数值是否正确
display PA0,PVA0,PINTA0,QA0,QVA0,QINTA0,QINT0,rhoq,rhoVA,scaleAq,deltaq,scaleAVA,deltaVA,ia,shrh,QLD0,QKD0,QLS0,QKS0,WL0,WK0,YH0,QH0;

variable
PA(a),PVA(a),PINTA(a),WL,WK,QA(a),QVA(a),QINTA(a),QINT(a,ap),QLD(a),QKD(a)
QLS,QKS,YH,QH(a);

*定义等式
equation
QAfn(a),QAFOCeq(a),PAeq(a),QVAfn(a),QVAFOC(a),PVAeq(a),QINTfn(a,ap),PINTAeq(ap),YHeq,QHeq(a), ComEqui(a),Leq,Keq;

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
PA(a)*QH(a)=e=shrh(a)*YH;

ComEqui(a)..
QA(a)=e=sum(ap,QINT(a,ap))+QH(a);

Leq..
Sum(a,QLD(a))=e=QLS;

Keq..
Sum(a,QKD(a))=e=QKS;


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
WK.l=1;
WL.l=1;
QLS.fx=QLS0;
QKS.fx=QKS0;
YH.l=YH0;
QH.l(a)=QH0(a);

*执行优化程序
model cge  /all/;
solve cge using mcp;

*下面模拟外界冲击的结果
QLS.fx=QLS0*1.08;
model sim1  /all/;
solve sim1 using mcp;

*End
