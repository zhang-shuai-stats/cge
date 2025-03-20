$title 第6章 例5.6.1  用直接交叉熵平衡SAM表
*编制GAMS程序语言，用直接交叉熵平衡SAM表。

*定义集合 ac
    set ac          /sec1,sec2,lab,hh,total/;
    set i(ac)        /sec1,sec2,lab,hh/;

alias (ac,acp);
alias (i,j);

table sam(*,*)
        sec1   sec2   lab   hh    total
sec1    52     45           150   247
sec2    95     48           90    233
lab     120    89                 209
hh                    192         192
total   267    182    192   240
;

parameters
    Q0(i,j)    initial value SAM表各个初始流量
    H0         sum of all transaction flows （初始流量总数）;

*Assignment for parameters
    Q0(i,j)=sam(i,j);
    H0=sum((i,j),sam(i,j));

display H0,sam;

Variables
    Q(i,j)       要调整的SAM表中的各个数值
    H            调整SAM表的总值
    Hratio       调整和原始两个总数的比例
    z            目标函数的数值即预期熵值;

*nonneg           每个变量必须是非负数
Positive variables Q(i,j);

equations
    totalsum         被调整的总数
    directentropy    目标函数 预期交叉熵
    balance          各个账户的平衡限制条件
    Hratiodef        Hratio 的定义和范围;

    totalsum..       H =e= sum((i,j)$sam(i,j),Q(i,j));
    Hratiodef..      Hratio =e= H/H0;
    directentropy..  z =e= sum((i,j)$sam(i,j),(1/H)*Q(i,j)*log(Q(i,j)/sam(i,j)))-log(Hratio);
    balance(i)..     sum(j$sam(i,j),Q(i,j)) =e= sum(j$sam(j,i),Q(j,i));

*对变量初始值赋值。
*这里对Hratio特别限制了范围。因为不限制的话，目标函数最小化时H会趋向无穷大
*得不到真实结果
    Q.l(i,j)=Q0(i,j);
    H.l=H0;
    Hratio.lo=0.5;
    Hratio.up=2;

model sambal  /all/;
solve sambal using nlp minimizing z;

display Q.l,H.l,Hratio.l, z.l;
*end 结束
