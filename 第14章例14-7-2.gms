$title  例14.7.2 开放经济的多活动部门多商品部门的CGE模型，新古典主义闭合

*定义集合所有账户 ac和生产活动a
set ac   /sec1,sec2soe,sec2pri,sec2fdi,sec3,com1,com2,com3,lab,cap,hhr,hhu,ent,gov,vatl,vatk,bustax,tariff,invsav,row,total/;
set a(ac)  /sec1,sec2soe,sec2pri,sec2fdi,sec3/;
set c(ac)  /com1,com2,com3/;
set f(ac)  /lab,cap/;
set h(ac)  /hhr,hhu/;
set vat(ac) /vatl,vatk/;
set acnt(ac)  除了总数之外的所有账户;
acnt(ac)=YES; acnt('total')=NO;

alias (ac,acp),(a,ap),(c,cp),(f,fp),(h,hp),(vat,vatp);
alias (acnt,acntp);

*这里SAM表是从外面用txt文件引进
table sam(ac,acp)
$INCLUDE I:\chap14QXSAM.inc

*先检查SAM表数值是否有误。方法：行列总和是否相等。
parameters
samchk(ac);

*行列总和误差，应该等于零;
samCHK(acnt)=sum(acntp,SAM(acntp,acnt))-sum(acntp,SAM(acnt,acntp));

display samchk,sam;

*生产函数参数
parameter  rhoAa(a)   /sec1 =   0.2,   sec2soe = 0.5,  sec2pri = 0.5, sec2fdi = 0.5, sec3 = 0.1/
           rhoVA(a)   /sec1     0.3,   sec2soe = 0.6,  sec2pri = 0.6, sec2fdi = 0.6, sec3   0.5/
           rhoQq(c)   /com1     0.4,   com2   0.7,  com3   0.2/
           rhoCET(c)  /com1     1.4,   com2   1.4,  com3   2.0/;

*定义参数
parameters
sax(a,c)         活动a和商品c之间的分配比例
scaleAa(a)       QA的CES函数参数
deltaAa(a)       QA的CES函数份额参数
scaleQq(c)       QQ的Arminton函数参数
deltaQq(c)       QQ的Arminton函数份额参数
scaleCET(c)      CET函数参数
deltaCET(c)      CET函数份额参数
scaleAVA(a)      VA的CES函数参数
deltaVA(a)       VA的CES函数劳动份额参数
ica(c,a)         中间投入的投入产出系数
shrh(c,h)        居民群h收入对商品c的消费支出份额
shrg(c)          政府收入中对商品c的消费支出份额
tih(h)           居民群h的所得税税率
tiEnt            企业所得税税率
tval(a)          对劳动投入的增值税率
tvak(a)          对资本投入的增值税率
tbus(a)          对生产活动a的营业税率，间接税率
transfrHG0(h)    政府对居民群h的转移收入
transfrEntG0     政府对企业的转移收入
transfrhent0(h)  企业对居民群h的转移收入（私人保险公司支付保险金等）
transfrhrow0(h)  国外对居民群h的转移支付（劳务输出，外汇汇款等）
transfrEntRow0   国外对企业的转移支付
transfrgRow0     国外对政府的转移支付
shifhl(h)        劳动要素禀赋中居民群h的份额
shifhk(h)        资本收入分配给居民群h的份额
shifentk         资本收入分配给企业的份额
mpc(h)           居民群h的边际消费倾向（这里也是平均消费倾向）
tm(c)            进口税率
te(c)            出口税率
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
PX0(c)           生产活动产出的QX商品c的价格
QX0(c)           生产活动产出的QX商品的数量
PQ0(c)           国内市场商品c的价格
QQ0(c)           国内市场商品c的数量
PM0(c)           进口商品c的价格
QM0(c)           进口商品c的数量
PE0(c)           国内生产商品c出口的价格
QE0(c)           生产商品c出口的数量
PD0(c)           国内生产国内使用商品c的价格
QD0(c)           国内生产国内使用商品c的数量
EXR0             汇率
pwm(c)           进口商品c的国际价格
pwe(c)           出口生产活动c商品的国际价格
QLSAGG0          劳动量总供应
QKSAGG0          资本量总供应
QLS0(h)          居民群h的劳动量供应
QKS0(h)          居民群h的资本量供应
YH0(h)           居民群h收入
EH0(h)           居民h消费总额
QH0(c,h)         居民h对商品c的需求
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
YHAGG0           所有居民的名义收入总量
;

*参数（包括外生变量）赋值与校调
PX0(c)=1;
QX0(c)=sum(a,sam(a,c))/PX0(c);
sax(a,c)=sam(a,c)/QX0(c);
PA0(a)=1;
PVA0(a)=1;
PD0(c)=1;
PE0(c)=1;
PM0(c)=1;
*PQ0（国内市场商品合成价格）由于有交易成本，起始值不一定等于1，要后面被估算求出来。
EXR0=1;
PINTA0(a)=1;
WK0=1;
WL0=1;
tval(a)=sam('vatl',a)/sam('lab',a);
tvak(a)=sam('vatk',a)/sam('cap',a);
tbus(a)=sam('bustax',a)/(sum(c,sam(c,a))+sum(f,sam(f,a)));
QLD0(a)=sam('lab',a)/WL0;
QKD0(a)=sam('cap',a)/WK0;
QVA0(a)=(SUM(f,sam(f,a))+sam('vatl',a)+sam('vatk',a))/PVA0(a);
QA0(a)=sam('total',a)/PA0(a);
QLS0(h)=sam(h,'lab')/WL0;
QKS0(h)=sam(h,'cap')/WK0;
QLSAGG0=sum(h,QLS0(h));
QKSAGG0=sum(h,QKS0(h))+sam('ent','cap')/WK0;

*下面为国外部分
*在tm(c)前加条件$sam('row',c)，表示必须有进口数额方才可以执行。这是因为要避免分母为零的情况。
tm(c)$sam('row',c)=sam('tariff',c)/sam('row',c);
pwm(c)=PM0(c)/((1+tm(c))*EXR0);
QM0(C)=(sam('row',c)+sam('tariff',c))/PM0(c);
te(c)=0;
pwe(c)=PE0(c)/((1-te(c))*EXR0);
QE0(c)=sam(c,'row')/PE0(c);
QD0(c)=QX0(c)-QE0(c);
QQ0(c)=QD0(c)+QM0(c);
PQ0(c)=(sam(c,'total')-sam(c,'row'))/QQ0(c);

*生产模块的参数校调估算，因为要先获取PQ数值，因此移到国外部分的后面
QINT0(c,a)=sam(c,a)/PQ0(c);
QINTA0(a)=SUM(c,QINT0(c,a));
ica(c,a)=QINT0(c,a)/QINTA0(a);
deltaAa(a)=PVA0(a)*QVA0(a)**(1-rhoAa(a))/(PVA0(a)*QVA0(a)**(1-rhoAa(a))+PINTA0(a)*QINTA0(a)**(1-rhoAa(a)));
scaleAa(a)=QA0(a)/(deltaAa(a)*QVA0(a)**rhoAa(a)+(1-deltaAa(a))*QINTA0(a)**rhoAa(a))**(1/rhoAa(a));
deltaVA(a)=((1+tval(a))*WL0)*QLD0(a)**(1-rhoVA(a))/(((1+tval(a))*WL0)*QLD0(a)**(1-rhoVA(a))+((1+tvak(a))*WK0)*QKD0(a)**(1-rhoVA(a)));
scaleAVA(a)=QVA0(a)/(deltaVA(a)*QLD0(a)**rhoVA(a)+(1-deltaVA(a))*QKD0(a)**rhoVA(a))**(1/rhoVA(a));
*CET function calibration
deltaCET(c)=PD0(c)*QD0(c)**(1-rhoCET(c))/(PD0(c)*QD0(c)**(1-rhoCET(c))+PE0(c)*QE0(c)**(1-rhoCET(c)));
scaleCET(c)=QX0(c)/(deltaCET(c)*QD0(c)**rhoCET(c)+(1-deltaCET(c))*QE0(c)**rhoCET(c))**(1/rhoCET(c));
*Arminton Condition 在国内生产和进口商品之间的关系
deltaQQ(c)=PD0(c)*QD0(c)**(1-rhoQQ(c))/(PD0(c)*QD0(c)**(1-rhoQq(c))+PM0(c)*QM0(c)**(1-rhoQq(c)));
scaleQQ(c)=QQ0(c)/(deltaQQ(c)*QD0(c)**rhoQq(c)+(1-deltaQq(c))*QM0(c)**rhoQq(c))**(1/rhoQq(c));
transfrhg0(h)=sam(h,'gov');
transfrhent0(h)=sam(h,'ent');
transfrhrow0(h)=sam(h,'row');
transfrEntG0=sam('ent','gov');
transfrEntRow0=0;
transfrgRow0=sam('gov','row');
shifhl(h)=(sam(h,'lab')/WL0)/QLSAGG0;
shifhk(h)=(sam(h,'cap')/WK0)/QKSAGG0;
shifentk=(sam('ent','cap')/WK0)/QKSAGG0;
YH0(h)=shifhl(h)*WL0*QLSAGG0+shifhk(h)*WK0*QKSAGG0+transfrhent0(h)+transfrhg0(h)+transfrhrow0(h)*EXR0;
tih(h)=sam('gov',h)/YH0(h);
mpc(h)=sum(c,sam(c,h))/((1-tih(h))*YH0(h));
EH0(h)=mpc(h)*(1-tih(h))*YH0(h);
QH0(c,h)=SAM(c,h)/PQ0(c);
shrh(c,h)=(PQ0(c)*QH0(c,h))/EH0(h);
YENT0=shifentk*WK0*QKSAGG0+transfrEntG0;
QINV0(c)=sam(c,'invsav')/PQ0(c);
EINV0=sum(c,PQ0(c)*QINV0(c));
tiEnt=sam('gov','ent')/YEnt0;
ENTSAV0=(1-tiEnt)*YENT0-sum(h,transfrhEnt0(h));
YHAGG0=sum(h,YH0(h));
YG0=sum(h,tih(h)*YH0(h))+tiEnt*YENT0+sum(a,tval(a)*WL0*QLD0(a)+tvak(a)*WK0*QKD0(a))
    +sum(a,sam('bustax',a))+sam('gov','tariff')+sam('gov','row');
QG0(c)=sam(c,'gov')/PQ0(c);
GSAV0=sam('invsav','gov');
EG0=YG0-GSAV0;
shrg(c)=PQ0(c)*QG0(c)/(EG0-sum(h,transfrhg0(h))-transfrEntG0);
GDP0=sum(c,sum(h,QH0(c,h))+QINV0(c)+QG0(c)+QE0(c)-QM0(c));
PGDP0=(sum(c,PQ0(c)*(sum(h,QH0(c,h))+QINV0(c)+QG0(c))+PE0(c)*QE0(c)-PM0(c)*QM0(c)
       +tm(c)*pwm(c)*QM0(c)*EXR0))/GDP0;
FSAV0=sam('invsav','row');
EG0chk=sum(c,sam(c,'gov'))+transfrhg0('hhr')+transfrhg0('hhu')+transfrEntG0-EG0;
vadded0=sum(a,(1+tval(a))*WL0*QLD0(a)+(1+tvak(a))*WK0*QKD0(a))
+sum(a,tbus(a)*(PINTA0(a)*QINTA0(a)+PVA0(a)*QVA0(a)))+sum(c,tm(c)*pwm(c)*QM0(c)*EXR0);
GDP0chk=vadded0-PGDP0*GDP0;

display sax,ica,PQ0,EG0,EG0chk,PGDP0,GDP0,vadded0,GDP0chk;

variable
PA(a),PVA(a),PINTA(a),WL,WK,QA(a),QVA(a),QINTA(a),QINT(c,a),QLD(a),QKD(a),QX(c),QD(c),QE(c),PX(c),PD(c),
PE(c),PQ(c),QQ(c),PM(c),QM(c),YH(h),QH(c,h),QINV(c),QG(c),YENT,ENTSAV,EINV,YG,EG,GSAV,QLSAGG,QKSAGG,FSAV,
GDP,PGDP,EXR,walras
;

*下面对等式定义
equation

QAfn(a),QAFOCeq(a),PAeq(a),QVAfn(a),QVAFOC(a),PVAeq(a),QINTfn(c,a),PINTAeq(a),QAQXeq(a),PXeq(c),CETfn(c),CETFOC(c),PXCET(c),PEeq(c),QQfn(c),QQfnNoImport(c),QQFOC(c),PQPDCNoImportfn(c),PQeq(c),
PMeq(c),YHeq(h),QHeq(c,h),YENTeq,ENTSAVeq,EINVeq,Ygeq,QGeq(c),GSAVeq,ComEqui(c),Leq,Keq,FEXeq,ISeq,GDPeq,PGDPeq
;

QAfn(a)..
QA(a)=e=scaleAa(a)*(deltaAa(a)*QVA(a)**rhoAa(a)+(1-deltaAa(a))*QINTA(a)**rhoAa(a))**(1/rhoAa(a));

QAFOCeq(a)..
PVA(a)/PINTA(a)=e=(deltaAa(a)/(1-deltaAa(a)))*(QINTA(a)/QVA(a))**(1-rhoAa(a));

PAeq(a)..
PA(a)*QA(a)=e=(1+tbus(a))*(PVA(a)*QVA(a)+PINTA(a)*QINTA(a));

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

QAQXeq(a)..
QA(a)=e=sum(c,sax(a,c)*QX(c));

PXeq(c)..
*PX(c)*QX(c)=e=sum(a,PA(a)*sax(a,c)*QA(a));
PX(c)=e=sum(a,PA(a)*sax(a,c));

CETfn(c)..
QX(c)=e=scaleCET(c)*(deltaCET(c)*QD(c)**rhoCET(c)+(1-deltaCET(c))*QE(c)**rhoCET(c))**(1/rhoCET(c));

CETFOC(c)..
PD(c)/PE(c)=e=(deltaCET(c)/(1-deltaCET(c)))*(QE(c)/QD(c))**(1-rhoCET(c));

PXCET(c)..
PX(c)*QX(c)=e=(PD(c)*QD(c)+PE(c)*QE(c));

PEeq(c)..
PE(c)=e=pwe(c)*(1-te(c))*EXR;

QQfn(c)$sam('row',c)..
QQ(c)=e=scaleQq(c)*(deltaQq(c)*QD(c)**rhoQq(c)+(1-deltaQq(c))*QM(c)**rhoQq(c))**(1/rhoQq(c));

QQfnNoImport(c)$(sam('row',c)=0)..
QQ(c)=e=QD(c);

QQFOC(c)$sam('row',c)..
PD(c)/PM(c)=e=(deltaQq(c)/(1-deltaQq(c)))*(QM(c)/QD(c))**(1-rhoQq(c));

PQPDCNoImportfn(c)$(sam('row',c)=0)..
PQ(c)=e=PD(c);

PQeq(c)..
PQ(c)*QQ(c)=e=PD(c)*QD(c)+PM(c)*QM(c);

PMeq(c)..
PM(c)=e=pwm(c)*(1+tm(c))*EXR;

YHeq(h)..
YH(h)=e=shifhl(h)*WL*QLSAGG+shifhk(h)*WK*QKSAGG+transfrhent0(h)+transfrhg0(h)+transfrhrow0(h)*EXR;

QHeq(c,h)..
PQ(c)*QH(c,h)=e=shrh(c,h)*mpc(h)*(1-tih(h))*YH(h);

YENTeq..
YENT=e=shifentk*WK*QKSAGG+transfrentg0+transfrEntRow0*EXR;

ENTSAVeq..
ENTSAV=e=(1-tiEnt)*YENT-sum(h,transfrhEnt0(h));

EINVeq..
EINV=e=sum(c,PQ(c)*QINV(c));

YGeq..
YG=e=sum(a,tval(a)*WL*QLD(a)+tvak(a)*WK*QKD(a))+sum(a,tbus(a)*(PINTA(a)*QINTA(a)+PVA(a)*QVA(a)))+sum(h,tih(h)*YH(h))
         +tiEnt*YENT+sum(c,tm(c)*pwm(c)*QM(c)*EXR)+sum(c,te(c)*pwe(c)*QE(c)*EXR)+transfrgrow0*EXR;

QGeq(c)..
PQ(c)*QG(c)=e=shrg(c)*(EG-sum(h,transfrhg0(h))-transfrEntg0);

GSAVeq..
GSAV=e=YG-EG;

ComEqui(c)..
QQ(c)=e=sum(a,QINT(c,a))+sum(h,QH(c,h))+QINV(c)+QG(c);

Leq..
Sum(a,QLD(a))=e=QLSAGG;

Keq..
Sum(a,QKD(a))=e=QKSAGG;

FEXeq..
sum(c,pwm(c)*QM(c))=e=sum(c,pwe(c)*QE(c))+transfrgrow0+FSAV;

ISeq..
EINV=e=sum(h,(1-mpc(h))*(1-tih(h))*YH(h))+ENTSAV+GSAV+EXR*FSAV+walras;

GDPeq..
GDP=e=sum(c,sum(h,QH(c,h))+QINV(c)+QG(c)+QE(c)-QM(c));

PGDPeq..
PGDP*GDP=e=sum(c,PQ(c)*(sum(h,QH(c,h))+QINV(c)+QG(c)))+sum(c,PE(c)*QE(c))-sum(c,PM(c)*QM(c))+sum(c,tm(c)*pwm(c)*QM(c)*EXR);

*赋予变量的初始值

PA.l(a)=PA0(a);
PVA.l(a)=PVA0(a);
PINTA.l(a)=PINTA0(a);
QA.l(a)=QA0(a);
QVA.l(a)=QVA0(a);
QINTA.l(a)=QINTA0(a);
QINT.l(c,a)=QINT0(c,a);
QLD.l(a)=QLD0(a);
QKD.l(a)=QKD0(a);
PX.l(c)=1;
QX.l(c)=QX0(c);
PD.l(c)=1;
QD.l(c)=QD0(c);
PE.l(c)=1;
QE.l(c)=QE0(c);
PQ.l(c)=1;
QQ.l(c)=QQ0(c);
PM.l(c)=1;
QM.l(c)=QM0(c);
YH.l(h)=YH0(h);
QH.l(c,h)=QH0(c,h);
YENT.l=YENT0;
ENTSAV.l=ENTSAV0;
EINV.l=EINV0;
YG.l=YG0;
EG.l=EG0;
GSAV.l=GSAV0;
WK.l=1;
EXR.l=1;
GDP.l=GDP0;
PGDP.l=PGDP0;
walras.l=0;

*新古典主义宏观闭合条件
QLSAGG.fx=QLSAGG0;
QKSAGG.fx=QKSAGG0;
WL.fx=1;
QINV.fx(c)=QINV0(c);
FSAV.fx=FSAV0;

*执行优化程序
model cge  /all/;
solve cge using mcp;

*下面模拟资本禀赋增加10％冲击的结果
QKSAGG.fx=QKSAGG0*1.1;

model sim1  /all/;
solve sim1 using mcp;

parameter
GDPmultiplier    资本禀赋增加10％对GDP的影响;
gdpmultiplier=(gdp.l-gdp0)/gdp0;
display gdpmultiplier;

*end
