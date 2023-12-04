

Attach("g2-jac.m");
Attach("add.m");


Q:=NumberField(Rationals());
Qx<x>:=PolynomialRing(Q);

C:=HyperellipticCurve(x*(x-1)*(x-2)*(x-5)*(x-6));

// curve apears in 
// David Grant, "A curve for which Coleman's effective Chabauty bound is sharp."  
// Proc. Amer. Math. Soc.  122  (1994),  no. 1, 317--319. 

J:=Jacobian(C);

// J is the rank 1 Jacobian appearing in 
// Gordon  and Grant, "Computing the Mordell-Weil rank of Jacobians of curves of genus two."  
// Trans. Amer. Math. Soc.  337  (1993),  no. 2, 807--824.

inf:=PointsAtInfinity(C)[1];
pts:=[inf,C![0,0],C![2,0],C![5,0],C![6,0],C![3,6],C![3,-6],C![10,120],C![10,-120]];

D:= (C![3,6]-inf)+(C![10,-120]-inf);  // D is an LLL reduced basis modulo torsion

assert chabauty([D],pts,C![3,6],7) eq [true,true,true,true,true,false,false,false,false];

// note that [3,-6] and [10,120] share the same residue class modulo 7
// and [3,6] and [10,-120] share the same residue class modulo 7,
// hence our Chabauty criterion must fail at these four points, and it does.


// another example

// K is a number field
// u, v  in K
// this constructs a genus 2 curve passing through seven rational points (see code) 
// it returns bas, inf
// where bas is a basis for the group generated by the differences of the points
// pts are the seven points

curveConstruct:=function(K,u,v);
	M:=Matrix([[1,1,1],[u^2,u,1],[v^2,v,1]]);
	N:=M^-1*Matrix([[1],[u^2],[v^2]]);
	a:=N[1,1];
	b:=N[2,1];
	c:=N[3,1];
	D:=LCM([Denominator(u),Denominator(v),Denominator(a),Denominator(b),Denominator(c)]);
	Kx<x>:=PolynomialRing(K);
	f:=D^2*(x*(x-1)*(x-u)*(x-v)*(x+1)+a*x^2+b*x+c);
	C:=HyperellipticCurve(f);
	P1:=C![1,D];
	P2:=C![u,D*u];
	P3:=C![v,D*v];
	P4:=C![1,-D];
	P5:=C![u,-D*u];
	P6:=C![v,-D*v];
	inf:=PointsAtInfinity(C)[1];
	J:=Jacobian(C);
	bas:=[P1-inf,P2-inf,P3-inf];
	pts:=[P1,P2,P3,P4,P5,P6,inf];
	return bas,pts;
end function;	
	
	
Qx<x>:=PolynomialRing(Rationals());
K<t>:=NumberField(x^3-2);
bas,pts:=curveConstruct(K,1+11*t,1+1021*t);	
print pts; 
// notice that pts consists of seven points P1,P2,..,P7
//

chabauty(bas,pts,pts[1],11);
// note that P1 and P2 are in the same residue class mod 11, and same for P4, P5
// so we expect to get false for P1, P2, P4, P5 and are not 
//surprised to get true for the others.


chabauty(bas,pts,pts[1],1021);
// note that P1 and P3 are in the same residue class mod 1021, and the same for P4, P6
// so we expect to get false for P1, P3, P4, P6 and are not surprised
// to get true for the others.

chabauty(bas,pts,pts[1],101);
// note that P2 and P3 are in the same residue class mod 101, and the same for
// P5, P6. Thus we expect to get false for P2, P3, P5, P6 and are not surprised
// to get true for the others.
