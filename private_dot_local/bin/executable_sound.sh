#!/bin/sh
# This is a shell archive (produced by GNU sharutils 4.11.1).
# To extract the files from this archive, save it to some FILE, remove
# everything before the `#!/bin/sh' line above, then type `sh FILE'.
#
lock_dir=_sh23531
# Made on 2012-10-17 08:32 EDT by <dperson@argos>.
# Source directory was `/home/dperson'.
#
# Existing files will *not* be overwritten, unless `-c' is specified.
#
# This shar contains:
# length mode       name
# ------ ---------- ------------------------------------------
#   9851 -rw-r--r-- dialog-question.ogg
#
MD5SUM=${MD5SUM-md5sum}
f=`${MD5SUM} --version | grep -E '^md5sum .*(core|text)utils'`
test -n "${f}" && md5check=true || md5check=false
${md5check} || \
  echo 'Note: not verifying md5sums.  Consider installing GNU coreutils.'
if test "X$1" = "X-c"
then keep_file=''
else keep_file=true
fi
echo=echo
save_IFS="${IFS}"
IFS="${IFS}:"
gettext_dir=
locale_dir=
set_echo=false

for dir in $PATH
do
  if test -f $dir/gettext \
     && ($dir/gettext --version >/dev/null 2>&1)
  then
    case `$dir/gettext --version 2>&1 | sed 1q` in
      *GNU*) gettext_dir=$dir
      set_echo=true
      break ;;
    esac
  fi
done

if ${set_echo}
then
  set_echo=false
  for dir in $PATH
  do
    if test -f $dir/shar \
       && ($dir/shar --print-text-domain-dir >/dev/null 2>&1)
    then
      locale_dir=`$dir/shar --print-text-domain-dir`
      set_echo=true
      break
    fi
  done

  if ${set_echo}
  then
    TEXTDOMAINDIR=$locale_dir
    export TEXTDOMAINDIR
    TEXTDOMAIN=sharutils
    export TEXTDOMAIN
    echo="$gettext_dir/gettext -s"
  fi
fi
IFS="$save_IFS"
if (echo "testing\c"; echo 1,2,3) | grep c >/dev/null
then if (echo -n test; echo 1,2,3) | grep n >/dev/null
     then shar_n= shar_c='
'
     else shar_n=-n shar_c= ; fi
else shar_n= shar_c='\c' ; fi
f=shar-touch.$$
st1=200112312359.59
st2=123123592001.59
st2tr=123123592001.5 # old SysV 14-char limit
st3=1231235901

if touch -am -t ${st1} ${f} >/dev/null 2>&1 && \
   test ! -f ${st1} && test -f ${f}; then
  shar_touch='touch -am -t $1$2$3$4$5$6.$7 "$8"'

elif touch -am ${st2} ${f} >/dev/null 2>&1 && \
   test ! -f ${st2} && test ! -f ${st2tr} && test -f ${f}; then
  shar_touch='touch -am $3$4$5$6$1$2.$7 "$8"'

elif touch -am ${st3} ${f} >/dev/null 2>&1 && \
   test ! -f ${st3} && test -f ${f}; then
  shar_touch='touch -am $3$4$5$6$2 "$8"'

else
  shar_touch=:
  echo
  ${echo} 'WARNING: not restoring timestamps.  Consider getting and
installing GNU `touch'\'', distributed in GNU coreutils...'
  echo
fi
rm -f ${st1} ${st2} ${st2tr} ${st3} ${f}
#
if test ! -d ${lock_dir} ; then :
else ${echo} "lock directory ${lock_dir} exists"
     exit 1
fi
if mkdir ${lock_dir}
then ${echo} "x - created lock directory ${lock_dir}."
else ${echo} "x - failed to create lock directory ${lock_dir}."
     exit 1
fi
# ============= dialog-question.ogg ==============
if test -n "${keep_file}" && test -f 'dialog-question.ogg'
then
${echo} "x - SKIPPING dialog-question.ogg (file already exists)"
else
${echo} "x - extracting dialog-question.ogg (binary)"
  sed 's/^X//' << 'SHAR_EOF' | uudecode &&
begin 600 dialog-question.ogg
M3V=G4P`"```````````:Z?%@`````(65@H(!'@%V;W)B:7,``````42L````
M````@#@!``````"X`4]G9U,`````````````&NGQ8`$```!*T(+S#BW_____
M__________^!`W9O<F)I<QT```!8:7!H+D]R9R!L:6)6;W)B:7,@22`R,#`W
M,#8R,@`````!!79O<F)I<R)"0U8!`$```"1S&"I&I7,6A!`:0E`9XQQ"SFOL
M&4),$8(<,DQ;RR5SD"&DH$*(6RB!T)!5``!```"'07@4A(I!""&$)3U8DH,G
M/0@AA(@Y>!2$:4$((8000@@AA!!"""&$13EHDH,G00@=A.,P.`R#Y3CX'(1%
M.5@0@R=!Z""$#T*XFH.L.0@AA"0U2%"#!CGH'(3"+"B*@L0PN!:$!#4HC(+D
M,,C4@PM"B)J#237X&H1G07@6A&E!""&$)$%(D(,&0<@8A$9!6)*#!CFX%(3+
M0:@:A"HY"!^$(#1D%0"0``"@HBB*HB@*$!JR"@#(```00%$4QW$<R9$<R;$<
M"P@-604```$`"```H$B*I$B.Y$B2)%F2)5F2)5F2YHFJ+,NR+,NR+,LR$!JR
M"@!(``!040Q%<10'"`U9!0!D```(H#B*I5B*I6B*YXB."(2&K`(`@```!```
M$#1#4SQ'E$3/5%77MFW;MFW;MFW;MFW;MFU;EF49"`U9!0!````0TFEFJ0:(
M,`,9!D)#5@$`"```@!&*,,2`T)!5``!```"`&$H.H@FM.=^<XZ!9#II*L3D=
MG$BU>9*;BKDYYYQSSLGFG#'..>><HIQ9#)H)K3GGG,2@60J:":TYYYPGL7G0
MFBJM.>><<<[I8)P1QCGGG":M>9":C;4YYYP%K6F.FDNQ.>><2+EY4IM+M3GG
MG'/..>><<\XYYYSJQ>D<G!/..>><J+VYEIO0Q3GGG$_&Z=Z<$,XYYYQSSCGG
MG'/..>><(#1D%0``!`!`$(:-8=PI"-+G:"!&$6(:,NE!]^@P"1J#G$+JT>AH
MI)0Z""65<5)*)P@-604```(`0`@AA1122"&%%%)((8448H@AAAARRBFGH()*
M*JFHHHPRRRRSS#++++/,.NRLLPX[##'$$$,KK<124VTUUEAK[CGGFH.T5EIK
MK;522BFEE%(*0D-6`0`@```$0@899)!12"&%%&*(*:><<@HJJ(#0D%4``"``
M@`````!/\AS1$1W1$1W1$1W1$1W1\1S/$251$B51$BW3,C734T55=677EG59
MMWU;V(5=]WW=]WW=^'5A6)9E699E699E699E699E698@-&05```"```@A!!"
M2"&%%%)(*<88<\PYZ"24$`@-604```(`"````'`41W$<R9$<2;(D2](DS=(L
M3_,T3Q,]411%TS15T15=43=M439ETS5=4S9=559M5Y9M6[9UVY=EV_=]W_=]
MW_=]W_=]W_=]70="0U8!`!(``#J2(RF2(BF2XSB.)$E`:,@J`$`&`$```(KB
M*([C.)(D29(E:9)G>9:HF9KIF9XJJD!HR"H``!``0````````(JF>(JI>(JH
M>([HB))HF9:HJ9HKRJ;LNJ[KNJ[KNJ[KNJ[KNJ[KNJ[KNJ[KNJ[KNJ[KNJ[K
MNJ[KNJX+A(:L`@`D``!T)$=R)$=2)$52)$=R@-"050"`#`"````<PS$D17(L
MR](T3_,T3Q,]T1,]TU-%5W2!T)!5```@`(`````````,R;`4R]$<31(EU5(M
M55,MU5)%U5-55555555555555555555555555555555555555555555-TS1-
M$P@-60D```$`T%ISS*V7CD'HK)?(**2@UTXYYJ37S"B"G.<0,6.8QU(Q0PS&
MED&$E`5"0U8$`%$``(`QR#'$''+.2>HD1<XY*AVEQCE'J:/444JQIEH[2J6V
M5&OCG*/44<HHI5I+JQVE5&NJL0``@``'`(``"Z'0D!4!0!0``($,4@HIA91B
MSBGGD%+*.>8<8HHYIYQCSCDHG93*.2>=DQ(II9QCSBGGG)3.2>:<D]))*```
M(,`!`"#`0B@T9$4`$"<`X'`<39,T310E31-%3Q1=UQ-%U94TS30U4515311-
MU515619-598E33--31154Q-%51554Y9-5;5ESS1MV515W195U;9E6_9]5Y9U
MW3--V195U;9-5;5U5Y9U7;9MW9<TS30U45153115UU15VS95U;8U471=455E
M6515679=6==55]9]3115U5--V1555995V=5E599U7W15W59=V==56=9]V]:%
M7]9]PJBJNF[*KJZKLJS[LB[[NNWKE$G33%,315751%%535>U;5-U;5L31=<5
M5=6615-U9566?5]U9=G71-%U156595%595F595UW95>W1575;55V?=]T75V7
M=5U89EOWA=-U=5V59=]795GW95W'UG7?]TS3MDW7U773577?UG7EF6W;^$55
MU755EH5?E67?UX7A>6[=%YY1577=E%U?5V59%VY?-]J^;CRO;6/;/K*O(PQ'
MOK`L7=LVNKY-F'7=Z!M#X3>&--.T;=-5==UT75^7==UHZ[I05%5=5V79]U57
M]GU;]X7A]GW?&%77]U59%H;5EIUA]WVE[@N55;:%W]9UYYAM75A^X^C\OC)T
M=5MHZ[JQS+ZN/+MQ=(8^`@``!AP```),*`.%AJP(`.($`!B$G$-,08@4@Q!"
M2"F$D%+$&(3,.2D9<U)"*:F%4E*+&(.0.28E<TY***&E4$I+H8360BFQA5):
M;*W5FEJ+-8326BBEM5!*BZFE&EMK-4:,0<B<DY(Y)Z64TEHHI;7,.2J=@Y0Z
M""FEE%HL*<58.2<E@XY*!R&EDDI,):480RJQE91B+"G%V%ILN<68<RBEQ9)*
M;"6E6%M,.;88<XX8@Y`Y)R5S3DHHI;524FN5<U(Z""EE#DHJ*<582DHQ<TY*
M!R&E#D)*):484TJQA5)B*RG56$IJL<68<TLQUE!2BR6E&$M*,;88<VZQY=9!
M:"VD$F,H)<868ZZMM1I#*;&5E&(L*=468ZV]Q9AS*"7&DDJ-):586XVYQAAS
M3K'EFEJLN<78:VVY]9IST*FU6E-,N;88<XZY!5ES[KV#T%HHI<502HRMM5I;
MC#F'4F(K*=582HJUQ9AS:['V4$J,):582THUMAAKCC7VFEJKM<68:VJQYIIS
M[S'FV%-K-;<8:TZQY5IS[KWFUF,!```##@```2:4@4)#5@(`40``!"%*,0:A
M08@QYZ0T"#'FG)2*,><@I%(QYAR$4C+G()224N8<A%)2"J6DDE)KH9124FJM
M``"``@<`@``;-"46!R@T9"4`D`H`8'`<R_(\4315V78LR?-$T315U;8=R_(\
M431-5;5MR_-$T315U75UW?(\4315575=7?=$4355U75E6?<]4315575=6?9]
MTU15U75E6;:%7S155W5=699EWUA=U75E6;9U6QA6U75=699M6S>&6]=UW?>%
M83DZMV[KNN_[PO$[QP``\`0'`*`"&U9'."D:"RPT9"4`D`$`0!B#D$%((8,0
M4D@AI1!22@D``!AP```(,*$,%!JR$@"(`@``")%22BF-E%)**:614DHII902
M0@@AA!!"""&$$$(((8000@@AA!!"""&$$$(((8000@@%`/A/.`#X/]B@*;$X
M0*$A*P&`<```P!BEF'(,.@DI-8PY!J&4E%)JK6&,,0BEI-1:2Y5S$$I)J;78
M8JR<@U!22JW%&F,'(:766JRQUIH[""FE%FNL.=@<2FDMQEASSKWWD%)K,=9:
M<^^]E]9BK#7GW(,0PK048ZZY]N![[RFV6FO-/?@@A%"QU5IS\$$((82+,??<
M@_`]""%<C#GG'H3PP0=A``!W@P,`1(*-,ZPDG16.!A<:LA(`"`D`(!!BBC'G
MG(,00@B14HPYYQR$$$(H)5**,>><@PY"""5DC#GG'(000BBEE(PQYYR#$$()
MI922.><<A!!"**644C+GH(,00@FEE%)*YQR$$$((I9122NF@@Q!"":644DHI
M(8000@FEE%)**26$$$()I9122BFEA!!***644DHII9000BFEE%)**:64$D(H
MI9122BFEE))"*:644DHII9124BBEE%)**:644DH)I9122BFEE)12204``!PX
M```$&$$G&5468:,)%QZ`0D-6`@!````4Q%93B9U!S#%GJ2$(,:BI0DHIAC%#
MRB"F*5,*(84A<XHA`J'%5DO%````$`0`"`@)`#!`4#`#``P.$#X'02=`<+0!
M``A"9(9(-"P$AP>5`!$Q%0`D)BCD`D"%Q47:Q05T&>""+NXZ$$(0@A#$X@`*
M2,#!"3<\\88GW.`$G:)2!P$`````<```#P``QP40$=$<1H;&!D>'QP=(2```
M````R`#`!P#`(0)$1#2'D:&QP='A\0$2$@````````````0$!````````@``
M``0$3V=G4P``P%,````````:Z?%@`@```/.O.ILG("$B(2$@("`I*BC!MRHK
MR:^[(2`A'R4H*[ZNKJ:@L+*RK+2^O<:UG,($3C;\5!D`$0`XNL26TK_?R_W_
M/.2J[G.\2DPBKRJ$0F:FP!5.*24@`@!C:5))US>ZU%9$LJ__:<H):=S,.`2$
MPA!0E0BKE2$A`@`TWZ?YO%XKXLW+!-:0IK/AY'44GUTUA,)00-Y5CP"$``![
MUGZ+2XJ*5<=7A_+<39GV147SHI0`A$)F%D!]MV8:Y```W\Q1O^%LA?QKT[[Y
MDR?(E7'9)+@$A$(RT,[W9*P$(@"@Y_$9[7K06?WE3;!H^C>M^`N)"`",0A*L
MZ%)]9I9```&`>*1)UE@>]!71CD+&![@=:<S2"G1"Q)GH:F<E"`(`8QRF:ZOK
M*QJ4P&BQ(]T])9>#[S<`!#W4$>RW?%NPV@9)?Q/-D;^M]13MN)D9R:K[%V9E
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
IQ!F2!5#.W,HF/I;\CZLBEB[^'S@[0!H`]R<``````````````(`;70#/
`
end
SHAR_EOF
  (set 20 11 03 02 10 22 07 'dialog-question.ogg'
   eval "${shar_touch}") && \
  chmod 0644 'dialog-question.ogg'
if test $? -ne 0
then ${echo} "restore of dialog-question.ogg failed"
fi
  if ${md5check}
  then (${MD5SUM} -c >/dev/null 2>&1 ||
            ${echo} 'dialog-question.ogg': 'MD5 check failed') << \SHAR_EOF
32b444b3b0208a4dedf24e58a1b25b9f  dialog-question.ogg
SHAR_EOF
  else
test `LC_ALL=C wc -c < 'dialog-question.ogg'` -ne 9851 && \
  ${echo} "restoration warning:  size of 'dialog-question.ogg' is not 9851"
  fi
fi
if rm -fr ${lock_dir}
then ${echo} "x - removed lock directory ${lock_dir}."
else ${echo} "x - failed to remove lock directory ${lock_dir}."
     exit 1
fi
exit 0