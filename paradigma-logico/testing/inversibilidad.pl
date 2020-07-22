vive(ruben,lanus).
vive(ana,lanus).
vive(laura,boedo).
vive(susi,bernal).

sonVecinos(P1,P2):-
    vive(P1,B),
    vive(P2,B),
    P1 \= P2.
esDelSur(P):- vive(P,lanus).
esDelSur(P):- vive(P,bernal).
