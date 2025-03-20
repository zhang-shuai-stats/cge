$title  例13.4.1 第13章的开放经济的CGE模型 新古典主义闭合

*定义集合所有账户 ac和生产活动a
set ac     /sec1,sec2,sec3,com1,com2,com3,lab,cap,hh,ent,gov,vatl,vatk,tariff,invsav,row,total/;
set a(ac)  /sec1,sec2,sec3/;
set c(ac)  /com1,com2,com3/;
set f(ac)  /lab,cap/;
set vat(ac) /vatl,vatk/; set acnt(ac)  除了总数之外的所有账户;
acnt(ac)=YES;
acnt('total')=NO;

alias (ac,acp),(a,ap),(c,cp),(f,fp),(vat,vatp),(acnt,acntp);

*注意下面对大型SAM表的写法。如果表上列账户太多，可以将右边的列的数据移到下面，
*重复每行的抬头，另外在列的抬头左边，加上一个"+"号。

table sam(ac,acp)
       sec1   sec2   sec3   com1   com2    com3   lab  cap
sec1                        1919.4
sec2                               3072.44
sec3                                       2576.1
com1   280    420    240
com2   377    520    378
com3   220    350    540
lab    650    700    690
cap    370    1140   660
hh                                                2040 1970
ent                                                    200
gov
vatl   71.5   77     75.9
vatk   40.7   125.4  72.6
tariff                      7.2    16      7
invsav
row                         230    290     95.9
total  2009.2 3332.4 2656.5 2156.6 3378.44 2679   2040 2170

     + hh      ent   gov   vatl  vatk  tariff invsav row    total
sec1                                                 89.8   2009.2
sec2                                                 259.96 3332.4
sec3                                                 80.4   2656.5
com1   1049.6        100                      67            2156.6
com2   1381.04       362.4                    360           3378.44
com3   1239          180                      150           2679
lab                                                         2040
cap                                                         2170
hh                   182                                    4192
ent                                                         200
gov    321     95.1        224.4 238.7 30.2                 909.4
vatl                                                        224.4
vatk                                                        238.7
tariff                                                      30.2
invsav 201.36  104.9 85                              185.74 577
row                                                         615.9
total  4192    200   909.4 224.4 238.7 30.2   577    615.9  18795.74
;

table Identac(a,c)
          com1     com2   com3
sec1        1
sec2                 1
sec3                        1
;

*先检查SAM表数值是否有误。方法：行列总和是否相等。行列总和误差，应该等于零;
parameters

samchk(ac);
samCHK(acnt)=sum(acntp,SAM(acntp,acnt))-sum(acntp,SAM(acnt,acntp));

display samchk;

*生产函数参数
parameter  rhoAa(a)   /sec1 =   0.2,   sec2 = 0.3,  sec3 = 0.1/
           rhoVA(a)   /sec1     0.3,   sec2   0.2,  sec3   0.5/
           rhoQq(c)   /com1     0.4,   com2   0.6,  com3   0.4/
           rhoCET(a)  /sec1     1.4,   sec2   1.4,  sec3   2.0/;

*定义参数
parameters

scaleAa(a)       QA的CES函数参数
deltaAa(a)       QA的CES函数份额参数
scaleQq(c)       QQ的Arminton函数参数
deltaQq(c)       QQ的Arminton函数份额参数
scaleCET(a)      CET函数参数
deltaCET(a)      CET函数份额参数
scaleAVA(a)      VA的CES函数参数
deltaVA(a)       VA的CES函数劳动份额参数
ica(c,a)         中间投入的投入产出系数
shrh(c)          居民群收入对商品c的消费支出份额
shrg(c)          政府收入中对商品c的消费支出份额
tih              居民的所得税税率
tiEnt            企业所得税税率
tval(a)          对劳动投入的增值税率
tvak(a)          对资本投入的增值税率
transfrHG0       政府对居民群的转移收入
transfrhent0     企业对居民群h的转移收入（私人保险公司支付保险金等）
shifhk           资本收入分配给居民的份额
shifentk         资本收入分配给企业的份额
mpc              居民的边际消费倾向（这里也是平均消费倾向）
tm(c)            进口税率

PA0(a)           生产活动a的价格
QA0(a)           生产活动a的数量
PVA0(a)          增值部分(含增值税）汇总价格
QVA0(a)          增值部分汇总量
PINTA0(a)        中间投入总价格
QINTA0(a)        中间投入总量
QINT0(c,a)       中间投入个量
QLD0(a)          劳动需求
QKD0(a)          资本需求
WL0              劳动价格
WK0              资本价格
PQ0(c)           国内市场商品c的价格
QQ0(c)           国内市场商品c的数量
PM0(c)           进口商品c的价格
QM0(c)           进口商品c的数量
PE0(a)           国内生产商品a出口的价格
QE0(a)           生产商品c出口的数量
PDA0(a)          国内生产国内使用活动a的价格
QDA0(a)          国内生产国内使用活动a的数量
PDC0(c)          国内生产国内使用商品c的价格
QDC0(c)          国内生产国内使用商品c的数量
EXR0             汇率
pwm(c)           进口商品c的国际价格
pwe(a)           出口生产活动a商品的国际价格
QLS0             劳动量总供应
QKS0             资本量总供应
YH0              居民群收入
EH0              居民消费总额
QH0(c)           居民对商品c的需求
YENT0            企业收入
EINV0            投资总额
QINV0(c)         对商品c的投资的最终需求
ENTSAV0          企业储蓄
YG0              政府收入
EG0              政府支出
QG0(c)           政府对商品c的需求
GSAV0            政府储蓄
PGDP0            国民生产总值价格指数
GDP0             实际国民生产总值
FSAV0            国外储蓄
EG0chk           用来检查和EG0是不是一致
vadded0          总增值，用它和支出法两个方法来检查是不是一致
GDP0chk          增值法和支出法两个方法是不是一致
;

*参数（包括外生变量）赋值与校调

*嵌套生产函数参数和起始值

PA0(a)=1;
PVA0(a)=1;
PINTA0(a)=1;
PDA0(a)=1;
PDC0(c)=1;
PE0(a)=1;
PM0(c)=1;
PQ0(c)=1;
EXR0=1;
WK0=1;
WL0=1;
QA0(a)=sam('total',a)/PA0(a);
*以下增值汇总看上去像是包含了增值税部分，实际应该看成是QVA单位被校调到PVA0=1的情况
QVA0(a)=(SUM(f,sam(f,a))+sam('vatl',a)+sam('vatk',a))/PVA0(a);
QINT0(c,a)=sam(c,a)/PQ0(c);
QINTA0(a)=SUM(c,QINT0(c,a));
ica(c,a)=QINT0(c,a)/QINTA0(a);
QLD0(a)=sam('lab',a)/WL0;
QKD0(a)=sam('cap',a)/WK0;
QLS0=sam('total','lab')/WL0;
QKS0=sam('total','cap')/WK0;
tval(a)=sam('vatl',a)/sam('lab',a);
tvak(a)=sam('vatk',a)/sam('cap',a);

*下面为国外部分
*在tm(c)前加条件$sam('row',c)，表示必须有进口数额方才可以执行。这是因为要避免分母为零的情况。
tm(c)$sam('row',c)=sam('tariff',c)/sam('row',c);
pwm(c)$sam('row',c)=PM0(c)/((1+tm(c))*EXR0);
QM0(c)=(sam('row',c)+sam('tariff',c))/PM0(c);
pwe(a)=PE0(a)/EXR0;
QE0(a)=sam(a,'row')/PE0(a);
QDA0(a)=sum(c,sam(a,c))/PDA0(a);
QDC0(c)=sum(a,sam(a,c))/PDC0(c);
QQ0(c)=QDC0(c)+QM0(c);

display QDA0,QDC0,QQ0;

deltaAa(a)=PVA0(a)*QVA0(a)**(1-rhoAa(a))/(PVA0(a)*QVA0(a)**(1-rhoAa(a))+PINTA0(a)*QINTA0(a)**(1-rhoAa(a)));
scaleAa(a)=QA0(a)/(deltaAa(a)*QVA0(a)**rhoAa(a)+(1-deltaAa(a))*QINTA0(a)**rhoAa(a))**(1/rhoAa(a));
deltaVA(a)=((1+tval(a))*WL0)*QLD0(a)**(1-rhoVA(a))/(((1+tval(a))*WL0)*QLD0(a)**(1-rhoVA(a))+((1+tvak(a))*WK0)*QKD0(a)**(1-rhoVA(a)));
scaleAVA(a)=QVA0(a)/(deltaVA(a)*QLD0(a)**rhoVA(a)+(1-deltaVA(a))*QKD0(a)**rhoVA(a))**(1/rhoVA(a));
*CET function calibration 内销和出口之间的选择  CET函数  校调参数
deltaCET(a)=PDA0(a)*QDA0(a)**(1-rhoCET(a))/(PDA0(a)*QDA0(a)**(1-rhoCET(a))+PE0(a)*QE0(a)**(1-rhoCET(a)));
scaleCET(a)=QA0(a)/(deltaCET(a)*QDA0(a)**rhoCET(a)+(1-deltaCET(a))*QE0(a)**rhoCET(a))**(1/rhoCET(a));
*Arminton Condition 在国内生产和进口商品之间的选择   校调参数
deltaQq(c)=PDC0(c)*QDC0(c)**(1-rhoQQ(c))/(PDC0(c)*QDC0(c)**(1-rhoQq(c))+PM0(c)*QM0(c)**(1-rhoQq(c)));
scaleQQ(c)=QQ0(c)/(deltaQq(c)*QDC0(c)**rhoQq(c)+(1-deltaQq(c))*QM0(c)**rhoQq(c))**(1/rhoQq(c));
*其它参数和外生变量的校调估算
transfrhg0=sam('hh','gov');
shifhk=(sam('hh','cap')/WK0)/QKS0;
shifentk=(sam('ent','cap')/WK0)/QKS0;
YH0=WL0*QLS0+shifhk*WK0*QKS0+transfrhg0;
tih=sam('gov','hh')/YH0;
mpc=sum(c,sam(c,'hh'))/((1-tih)*YH0);
EH0=mpc*(1-tih)*YH0;
QH0(c)=SAM(c,'hh')/PQ0(c);
shrh(c)=(PQ0(c)*QH0(c))/EH0;
YENT0=shifentk*WK0*QKS0;
QINV0(c)=sam(c,'invsav')/PQ0(c);
EINV0=sum(c,PQ0(c)*QINV0(c));
tiEnt=sam('gov','ent')/YEnt0;
ENTSAV0=(1-tiEnt)*YENT0;
YG0=tih*YH0+tiEnt*YENT0+sum(a,tval(a)*WL0*QLD0(a)+tvak(a)*WK0*QKD0(a))+sam('gov','tariff');
QG0(c)=sam(c,'gov')/PQ0(c);
GSAV0=sam('invsav','gov');
EG0=YG0-GSAV0;
shrg(c)=PQ0(c)*QG0(c)/(EG0-transfrhg0);
GDP0=sum(c,QH0(c)+QINV0(c)+QG0(c)-QM0(c))+sum(a,QE0(a));
PGDP0=(sum(c,PQ0(c)*(QH0(c)+QINV0(c)+QG0(c)-PM0(c)*QM0(c)+tm(c)*pwm(c)*QM0(c)*EXR0))+sum(a,PE0(a)*QE0(a)))/GDP0;
FSAV0=sam('invsav','row');

EG0chk=sum(c,sam(c,'gov'))+transfrhg0-EG0;
vadded0=sum(a,(1+tval(a))*WL0*QLD0(a)+(1+tvak(a))*WK0*QKD0(a))+sum(c,tm(c)*pwm(c)*QM0(c)*EXR0);
GDP0chk=vadded0-PGDP0*GDP0;

display ica,PQ0,EG0,EG0chk,PGDP0,GDP0,vadded0,GDP0chk,identac,shrg;

variable
PA(a),PVA(a),PINTA(a),QA(a),QVA(a),QINTA(a),QINT(c,a),WL,WK,QLD(a),QKD(a),PDA(a),QDA(a),PDC(c),QDC(c),PE(a),QE(a),
EXR,PQ(c),QQ(c),PM(c),QM(c),YH,QH(c),YENT,ENTSAV,EINV,YG,EG,QG(c),GSAV,FSAV,QLS,QKS,PGDP,GDP,WALRAS
;

*下面对等式定义。为了节省空间，用逗号分开equation,以压缩空间。
*劳动和要素供应量等于禀赋的等式，由后面赋值固定的指令QLS.fx=QLS0和QKS.fx=QKS0 完成。
equation
QDCQDA(c),PDCPDA(c),QAfn(a),QAFOCeq(a),PAeq(a),QVAfn(a),QVAFOC(a),PVAeq(a),QINTfn(c,a),PINTAeq(a),
CETfn(a),CETFOC(a),PCETeq(a),PEeq(a),QQfn(c),QQFOC(c),PQeq(c),PMeq(c),Yheq,QHeq(c),YENTeq,ENTSAVeq,EINVeq,
Ygeq,QGeq,GSAVeq,ComEqui(c),Leq,Keq,FEXeq,GDPeq,PGDPeq,Iseq
;

QAfn(a)..
QA(a)=e=scaleAa(a)*(deltaAa(a)*QVA(a)**rhoAa(a)+(1-deltaAa(a))*QINTA(a)**rhoAa(a))**(1/rhoAa(a));

QAFOCeq(a)..
PVA(a)/PINTA(a)=e=(deltaAa(a)/(1-deltaAa(a)))*(QINTA(a)/QVA(a))**(1-rhoAa(a));

PAeq(a)..
PA(a)*QA(a)=e=(PVA(a)*QVA(a)+PINTA(a)*QINTA(a));

QVAfn(a)..
QVA(a)=e=scaleAVA(a)*(deltaVA(a)*QLD(a)**rhoVA(a)+(1-deltaVA(a))*QKD(a)**rhoVA(a))**(1/rhoVA(a));

QVAFOC(a)..
((1+tval(a))*WL)/((1+tvak(a))*WK)=e=(deltaVA(a)/(1-deltaVA(a)))*(QKD(a)/QLD(a))**(1-rhoVA(a));

PVAeq(a)..
PVA(a)*QVA(a)=e=(1+tval(a))*WL*QLD(a)+(1+tvak(a))*WK*QKD(a);

QINTfn(c,a)..
QINT(c,a)=e=ica(c,a)*QINTA(a);

PINTAeq(a)..
PINTA(a)=e=SUM(c,ica(c,a)*PQ(c));

CETfn(a)..
QA(a)=e=scaleCET(a)*(deltaCET(a)*QDA(a)**rhoCET(a)+(1-deltaCET(a))*QE(a)**rhoCET(a))**(1/rhoCET(a));

CETFOC(a)..
PDA(a)/PE(a)=e=(deltaCET(a)/(1-deltaCET(a)))*(QE(a)/QDA(a))**(1-rhoCET(a));

PCETeq(a)..
PA(a)*QA(a)=e=PDA(a)*QDA(a)+PE(a)*QE(a);

PEeq(a)..
PE(a)=e=pwe(a)*EXR;

QQfn(c)..
QQ(c)=e=scaleQq(c)*(deltaQq(c)*QDC(c)**rhoQq(c)+(1-deltaQq(c))*QM(c)**rhoQq(c))**(1/rhoQq(c));

QQFOC(c)..
PDC(c)/PM(c)=e=(deltaQq(c)/(1-deltaQq(c)))*(QM(c)/QDC(c))**(1-rhoQq(c));

PQeq(c)..
PQ(c)*QQ(c)=e=PDC(c)*QDC(c)+PM(c)*QM(c);

PMeq(c)..
PM(c)=e=pwm(c)*(1+tm(c))*EXR;

*下面两个函数是从生产活动a到商品c的映射关系
QDCQDA(c)..
QDC(c)=e=sum(a,identac(a,c)*QDA(a));

PDCPDA(c)..
PDC(c)=e=sum(a,identac(a,c)*PDA(a));

YHeq..
YH=e=WL*QLS+shifhk*WK*QKS+transfrhg0;

QHeq(c)..
PQ(c)*QH(c)=e=PQ(c)*shrh(c)*mpc*(1-tih)*YH;

YENTeq..
YENT=e=shifentk*WK*QKS;

ENTSAVeq..
ENTSAV=e=(1-tiEnt)*YENT;

EINVeq..
EINV=e=sum(c,PQ(c)*QINV0(c));

YGeq..
YG=e=sum(a,tval(a)*WL*QLD(a)+tvak(a)*WK*QKD(a))+tih*YH
         +tiEnt*YENT+sum(c,tm(c)*pwm(c)*QM(c)*EXR);

QGeq(c)..
PQ(c)*QG(c)=e=shrg(c)*(EG-transfrhg0);

GSAVeq..
GSAV=e=YG-EG;

ComEqui(c)..
QQ(c)=e=sum(a,QINT(c,a))+QH(c)+QINV0(c)+QG(c);

Leq..
Sum(a,QLD(a))=e=QLS;

Keq..
Sum(a,QKD(a))=e=QKS;

FEXeq..
sum(c,pwm(c)*QM(c))=e=sum(a,pwe(a)*QE(a))+FSAV;

GDPeq..
GDP=e=sum(c,QH(c)+QINV0(c)+QG(c)-QM(c))+sum(a,QE(a));

PGDPeq..
PGDP*GDP=e=sum(c,PQ(c)*(QH(c)+QINV0(c)+QG(c)))+sum(a,PE(a)*QE(a))-sum(c,PM(c)*QM(c))+sum(c,tm(c)*pwm(c)*QM(c)*EXR);

ISeq..
EINV=e=(1-mpc)*(1-tih)*YH+ENTSAV+GSAV+EXR*FSAV+walras;



*赋予变量的初始值

PDA.l(a)=1;
QDA.l(a)=QDA0(a);
PDC.l(c)=1;
QDC.l(c)=QDC0(c);
PA.l(a)=PA0(a);
PVA.l(a)=PVA0(a);
PINTA.l(a)=PINTA0(a);
QA.l(a)=QA0(a);
QVA.l(a)=QVA0(a);
QINTA.l(a)=QINTA0(a);
QINT.l(c,a)=QINT0(c,a);
QLD.l(a)=QLD0(a);
QKD.l(a)=QKD0(a);
WK.l=1;
PE.l(a)=1;
QE.l(a)=QE0(a);
EXR.l=1;
PQ.l(c)=1;
QQ.l(c)=QQ0(c);
PM.l(c)=1;
QM.l(c)=QM0(c);
YH.l=YH0;
QH.l(c)=QH0(c);
YENT.l=YENT0;
ENTSAV.l=ENTSAV0;
EINV.l=EINV0;
YG.l=YG0;
EG.l=EG0;
GSAV.l=GSAV0;
PGDP.l=PGDP0;
GDP.l=GDP0;
WALRAS.l=0;


*下面对几个变量赋值固定，使它们变成参数或外生变量。WL规定为价格基准
WL.fx=1;
QLS.fx=QLS0;
QKS.fx=QKS0;
FSAV.fx=FSAV0;

*执行优化程序
model cge  /all/;
solve cge using mcp;

display QINT.l,QINTA.l,QINT0,qda.l,qdc.l,qm.l,qe.l,qq.l,tm,pwm,pwe,tval,tvak,gdp.l,pgdp.l,WALRAS.l;

*下面模拟劳动禀赋增加冲击的结果及劳动要素供应乘数
Parameter
GDPold;
GDPold=GDP.l;
QLS.fx=QLS0+1;

model sim  /all/;
solve sim using mcp;

Parameter
Multiplier labor multiplier;
Multiplier=(GDP.l-GDPold)/1;

display  Multiplier;

*END
