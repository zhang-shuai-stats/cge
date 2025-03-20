$title 第5章例5.5.1  RAS 平衡法

*定义集合 只需用下面的子集i就够了
set i       /sec1,sec2,lab,hh/;
alias(i,j);

*目标总值取名tartot
table SAM(*,*) the social accounting matrix
       sec1 sec2 lab  hh  total  tartot
sec1   52   45        150  247   270
sec2   95   48        90   233   233
lab    120  89             209   210
hh               192       192   210
total  267  182  192  240
tartot 270  233  210  210
;

parameter

rowdis(i)         行汇总值与目标值之差
condis(j)         列汇总值与目标值之差
maxdis         所有行列汇总与目标值差的最大值
iter            循环次数 number of iteration
;

*用循环执行程序while(  )
*赋予循环初始值与跳出循环的条件
maxdis=0.1;
iter=1;

*while括号里第一句是循环停止的条件。这里规定循环次数在5000次内,当行列值和目标值的最大误差小于1e-10跳出循环
while( iter < 5000 and maxdis > 1e-10 ,

*根据列的目标汇总值，调整SAM (R adjustment)
sam('total',j)=sum(i,sam(i,j));
sam(i,j)=sam(i,j)/sam('total',j)*sam('tartot',j);

*根据行的目标汇总值，调整SAM (S adjustment)
sam(i,'total')=sum(j,sam(i,j)) ;
sam(i,j)=sam(i,j)/sam(i,'total')*sam(i,'tartot');

*检验本循环调整后的最大误差
condis(j)=abs(sum(i,sam(i,j))-sam('tartot',j));
rowdis(i)=abs(sum(j,sam(i,j))-sam(i,'tartot'));
*比较这一轮结果中的最大值
maxdis=max{smax{i,rowdis(i)},smax{j,condis(j)}};

iter=iter+1;
);
*上面的括号意为回到while那儿去重复循环

display sam,maxdis,iter;

*end 结束
