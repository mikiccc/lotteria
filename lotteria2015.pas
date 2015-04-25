

(*
Estrazione della lotteria del Palio di San Vincenzo
Prima versione del programma scritta a maggio del 2007 in turbo pascal compilata con il fp_compiler sotto ubuntu
Rivista per l'estrazione del 18 maggio 2008
aggiornata per l'estrazione del 17 maggio 2009
aggiornata per l'estrazione del 16 maggio 2010
aggiornata per l'estrazione del 21 maggio 2011
v. 0.31 aggiornata il 27 aprile 2014 per l'estrazione relativa alla camminata di monsano
v. 0.4 aggiornata il 26 aprile 2015 per l'estrazione relativa alla camminata di monsano

bisogna caricare tutti i biglietti (si puo' mettere da un certo numero fino a un altro per caricare interi blocchetti)

e' possibile escludere i biglietti non venduti (va fatto singolarmente e non si può mettere un intervallo)

in questa implementazione vengono gestiti solo biglietti numerici ma visto che il sistema funziona scegliendo a caso sull'indice dell'array, è possibile modificarlo per gestire anche biglietti con caratteri (serie) e numeri

*)


uses crt;
const

 (* numero massimo di biglietti da caricare *)

 max_biglietti=2500;

(* numero di premi *)
 premi=15;

(*

* debug
- false per il funzionamento normale
- true stampa a video e su file di log tutto il debug del programma compresa una statistica
  per indicare quante volte vengono presi in considerazioni i singoli biglietti e quindi capire
  se la funzione random e' utilizzata correttamente

*)

 debug:boolean=false;

(*

* stampa_mescolata
- false per il funzionamento normale
- true per stampare il numero di mescolata. quando si mette si incasina la stampa a video

*)

 stampa_mescolata:boolean=false;

var
  i, indice, estratto: word;
  j: longint;
  biglietti: array [1..max_biglietti] of word;
  test: array [1..max_biglietti] of word;
  log:text;
  ch:char;

(*

procedura per caricare i biglietti

- inizio e fine sono i parametri che contengono l'intervallo dei biglietti da caricare (tipicamente il primo e l'ultimo biglietto di un blocchetto)
- i è la variabile globale che ha l'indice dell'array e non deve essere azzerata
- k è il numero del biglietto che viene caricato
*)

procedure caricamento_biglietti (inizio,fine:word);

var
 k:word;

begin

 (* inizializzo k a -1 perche' metto il +1 all'interno del ciclo *)

 k:=inizio-1;
 if debug=true then write ('Biglietti dal ',inizio,' al ');

 repeat
  i:=i+1;
  k:=k+1;
  biglietti[i]:=k;
 until k=fine;

 if debug then writeln (fine,' per un totale di biglietti caricati=',i);
end;

(*

procedura per escludere un biglietto già caricato

utile se ho inserito tutto un blocchetto e devo eliminare solo alcuni biglietti non venduti

- escluso (il biglietto da escludere)
- x l'indice per scorrere tutti i biglietti
*)

procedure escludi_biglietto (escluso:word);

var
 x:word;

begin
 x:=0;
 if debug then write ('Esclusione biglietto ',escluso,'  ');
 repeat
  x:=x+1;
  if biglietti[x]=escluso then
       begin

        (* metto a 0 il valore sull'array *)

        biglietti[x]:=0;

        (* riduco i di 1 per indicare in numero dei biglietti venduti *)

	i:=i-1;


        if debug then writeln ('Trovato');
       end;
 until x=max_biglietti;

 if debug then writeln;

end;



(*

inizio programma

*)

begin


 writeln; writeln; writeln; writeln; writeln; writeln;
 writeln ('Lotteria v. 0.4 scritto per la lotteria di Monsano');
 writeln;
 writeln ('a cura di Michele Focanti');

 assign  (log,'lotteria2015.log');
 rewrite (log);

 (* azzero tutti i biglietti *)
 for i:=1 to max_biglietti do
  begin
    biglietti[i]:=0;
    test[i]:=0;
  end;


 if debug then writeln ('Caricamento blocchetti dei biglietti');


(* i conta il numero di biglietti venduti *)

 i:=0;


(*

caricamento biglietti sull'array
sarebbe meglio farglieli leggere da un file di testo

per la lotteria della camminata i biglietti vanno da 1 a 2500. per il palio c'erano numeri alti

*)

 caricamento_biglietti (1,1000);
 caricamento_biglietti (1022,1100);
 caricamento_biglietti (1101,1200);
 caricamento_biglietti (1237,1300);
 caricamento_biglietti (1345,1400);
 caricamento_biglietti (1401,1500);
 caricamento_biglietti (1523,1600);

(*
caricamento_biglietti (23101,25000);

*)


(* esclusione di singoli biglietti non venduti *)

 if debug then writeln ('esclusione biglietti non venduti');

(*  esempio per esclusione *)

(*
 escludi_biglietto (14989);
 escludi_biglietto (15004);
*)

 if debug then
  begin
   writeln ('Caricati ',i,' biglietti');
   writeln (log,'Caricati ', i,'  biglietti');
  end;


(* stampa biglietti caricati sul file di log *)

 if debug then
  begin
   for i:=1 to max_biglietti do
    begin
     writeln (log, 'biglietto ',i,' =',biglietti[i]);
    end;
  end;

 writeln; writeln; writeln; writeln; writeln; writeln;

 writeln ('Pronti per l''estrazione di ',premi,' premi');
 writeln ('Premi un tasto per procedere con l''estrazione');
 ch:=readkey;
 writeln (ch);

 writeln; writeln; writeln; writeln; writeln; writeln;

 writeln (log); writeln (log); writeln (log);
 writeln (log,'Estrazione di ', premi, ' premi');


(* azzero il random *)

 randomize;

(* estrazione dei premi *)

for i:=1 to premi do
 begin
  writeln;
  writeln ('MESCOLAMENTO IN CORSO...');
  writeln ('* \|/ \|/ \|/ *');
  writeln ('Premi un tasto per estrarre il biglietto');

  (* calcolo random del biglietto finche' non viene premuto un tasto *)

   (* j indica il numero delle mescolate *)

   j:=0;
   repeat
    j:=j+1;

    (* con questa formula si prendono in considerazione tutti gli indici del vettore *)

    indice:=1+random(max_biglietti);

    (* serve con il debug attivo per capire quante volte viene "scorso" il biglietto durante il mescolamento *)
    (* conteggia il numero delle volte che un biglietto viene considerato *)

    test[indice]:=test[indice]+1;


    if stampa_mescolata then
      begin
       writeln ('mescolata: ',j);
      end;

   until keypressed and (biglietti[indice]<>0);

   ch:=readkey;

   estratto:=biglietti[indice];

 writeln;

 write (premi-i+1,'° premio al biglietto * ',estratto,' *');
 write (log,premi-i+1,'° premio al biglietto * ',estratto,' *');

  (* azzero il biglietto estratto per escluderlo dalla prossima estrazione*)
    biglietti[indice]:=0;
 
if debug then
  begin
   writeln ('  mescolate=',j);
   writeln (log,'  mescolate=',j);
  end;
  writeln (log);
   
 writeln;
 writeln;

 end; (* for *)

 if debug then
  begin
    writeln (log); writeln (log,'stampa delle volte che è stato preso in considerazione il biglietto durante il mescolamento. i biglietti estratti compariranno come 0 perché sono stati azzerati per evitare la doppia estrazione'); writeln (log);
   for i:=1 to max_biglietti do
    begin
     writeln (log, 'biglietto ',biglietti[i],' uscito ',test[i],' volte');
    end;
  end;


 writeln (log);

 close(log);

 writeln; writeln; writeln; writeln; writeln; writeln;


end.

