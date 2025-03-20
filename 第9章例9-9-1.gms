$title  例9.9.1 LES需求函数的参数校调估算、函数复制检验、和模拟

*生产部门和商品包括农业 制造业 服务
set a 生产部门和商品 /agri,manu,serv/;
set inst 机构        /hh/;

alias (a,ap);

table sam(a,inst)    居民消费额
         hh
agri     500
manu     450
serv     350
;

*读取LES需求函数的弹性和弗里希参数数据
parameter  LESelas(a)  /agri    0.5,    manu   1.0,  serv   1.2 /
           Frisch     /-2/;

parameters
PA0(a)         商品a的价格
QH0(a)         居民对商品a的需求
EH0            居民消费总额
bgtshr(a)      LES函数中消费预算商品a的份额
bgtshrchk      LES函数中消费预算商品a的份额参数检验
LESbeta(a)     LES边际消费额， �@
LESbetachk     LES边际消费额参数和检验
LESsub(a)      LES消费函数生存消费量
;

PA0(a)=1;
QH0(a)=sam(a,'hh')/PA0(a);
EH0=sum(a,PA0(a)*QH0(a));
bgtshr(a)=SAM(a,'hh')/EH0;
bgtshrchk=sum(a,bgtshr(a));
*下面求LES边际消费额beta
*为了符合beda相加等于1的限制条件 要将beda按规模调整。
LESbeta(a)=LESelas(a)*bgtshr(a)/(sum(ap,LESelas(ap)*bgtshr(ap)));
LESbetachk=sum(a,LESbeta(a));
LESsub(a)=sam(a,'hh')+(LESbeta(a)/PA0(a))*(EH0/Frisch);

display frisch,PA0,QH0,EH0,bgtshr,bgtshrchk,LESbeta,LESbetachk,LESsub,LESelas;

variable
PA(a),QH(a),EH
;

equation
QHeq(a)
;

QHeq(a)..
PA(a)*QH(a)=e=PA(a)*LESsub(a)+LESbeta(a)*(EH-sum(ap,PA(ap)*LESsub(ap)));

PA.fx(a)=PA0(a);
QH.l(a)=QH0(a);
EH.fx=EH0;

*执行优化程序
model LES  /all/;
solve LES using mcp;

*复制检验
display PA.l,QH.l,EH.l;

*下面模拟居民消费额EH增长20%的结果
EH.fx=EH0*1.2;

model sim1  /all/;
solve sim1 using mcp;
display PA.l,QH.l,EH.l;

*下面模拟价格又增长20%的结果。如果实际需求和原来一样，证明函数是零阶齐次的。
PA.fx(a)=PA0(a)*1.2;

model sim2  /all/;
solve sim2 using mcp;
display PA.l,QH.l,EH.l;

*End
