$title 例7.6.1   CES函数 Demonstration for a CES function

*calibration 校调估算参数

parameter
elas            elasticity （弹性）
rho             CES function exponent rho （CES函数幂）
delta1          share for good x1 (x1 的份额)
delta2          share for good x2 (x2 的份额)
scaleA          CES function scale factor A （CES函数的规模因素A）
x1O             initial value of input （x1 初始值）
x2O             initial value of input （x2 初始值）
qO              initial value of output q  （q 初始值）
w1O             initial value of price of input 1 （要素1价格的初始值）
w2O             initial value of price of input 2  （要素2价格的初始值）
pO              initial value of price of q （商品价格的初始值）
;

* 对参数和外生变量赋值定义。通常用初始值，或者从SAM或其它外界信息给定。
elas =0.5;
w1O=1;
w2O=1;
pO=1;
x1O=26;
x2O=39;
qO=65;

* 对其它没有直接数值的参数校调估算。
rho=1-1/elas;
delta1=w1O*x1O**(1-rho)/(w1O*x1O**(1-rho)+w2O*x2O**(1-rho));
delta2=1-delta1;
scaleA=qO/(delta1*x1O**rho+delta2*x2O**rho)**(1/rho);

* "display" 指令。将校调估算出来的参数以及变量的数值展现出来。
display  rho ,delta1,delta2 ,scaleA, x1O,x2O,qO,w1O,w2O,pO
;

* 下面是复制检验参数估算值正确与否

* 宣称和定义内生变量
variable

x1      要素1数量
x2      要素2数量
q       商品q数量
w1      要素价格 1
w2      要素价格 2
p       商品q的价格
;

*定义等式
equation

Qeq         production function （生产函数）
FOCeq       first order condition for cost minimization （成本最小化的一阶条件）
PRICEeq     commodity price equals the unit total cost （商品价格等于产品单位成本）
;

Qeq..
q=e=scaleA*(delta1*x1**rho+delta2*x2**rho)**(1/rho) ;

FOCeq..
delta1/delta2=e=w1*x1**(1-rho)/(w2*x2**(1-rho));

PRICEeq..
p*q=e=w1*x1+w2*x2;

*给变量赋予起始价值。在下面的写法中， x1, x2 和 p 作为内生变量。
p.l=pO;
x1.l=x1O;
x2.l=x2O;

*将q, w1, w2的数值用fx固定。它们的性质从变量改成参数
q.fx=qO;
w1.fx=w1O;
w2.fx=w2O;

*执行模型,复制SAM的数值。这里是复制原来给予的CES函数的初始数值。可以检查估算的参数和模型设置对不对，
*这个练习使用的解算法仍然是MCP（mixed complementarity problems), 是CGE模型最经常用的。

model CES  /all/;
solve CES using mcp;

*将重新复制的初始模型的变量数值展现，看是否和原来一致
parameter  repbase;
repbase('input x1')=x1.l ;
repbase('input x2')=x2.l ;
repbase('q price pO')=p.l ;
display  repbase;

*============
*模拟部分
*============

*政策变动"shock"后，价格w1现在增加了10%, 有1.1乘以初始价格
*设置新的外部变量数值
*执行模型

w1.fx=1.1*w1O;
solve CES using mcp;

*将模拟的模型结果的变量数值展现
parameter  simoutput ;
simoutput('input x1')=x1.l ;
simoutput('input x2')=x2.l ;
simoutput('q price p')=p.l ;
display  simoutput;

*end
