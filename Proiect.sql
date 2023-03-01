--BAZE DE DATE IN CONTABILITATE

--I.

/*1) SA SE CREEZE TABELELE:

a) SOCIETATI
- Nume coloana          CUI          Tip_societate     Denumire_societate     Localitate     Telefon
- Tipul Restrictiei    Primary key   
- Tip data             Number          Varchar2              Varchar2          Varchar2       Varchar2
-Lungime                 8                5                   30                  30           20
*/

CREATE TABLE RusuIulian_Societati
(CUI number(8) primary key,
Tip_societate varchar2(5),
Denumire_societate varchar2(30),
Localitate varchar2(30),
Telefon varchar2(20)
);

/*b) ACTIVE
- Nume coloana          ID_Activ       Tip_activ    Denumire_activ    Data_adaugare     Valoare_activ    Amortizare    Valoare_amortizare                           CUI
- Tipul Restrictiei    Primary key                                                                                                         Foreign Key- Referinta Tabela Societati, coloana CUI
- Tip data             Number          Varchar2         Varchar2          Date            Number            Char              Number                              Number
-Lungime                 5                20               30                               10                 2                10                                   8
*/
CREATE TABLE RusuIulian_Active
(Id_activ number(5) primary key,
Tip_activ varchar2(20),
Denumire_activ varchar2(30),
Data_adaugare date,
Valoare_activ number(10),
Amortizare char(2),
Valoare_amortizare number(10),
CUI number(8),
Constraint FK_CUI_A FOREIGN KEY (CUI) REFERENCES RusuIulian_Societati (CUI)
);
Describe RusuIulian_;
--2) Sa se adauge coloana:   Descriere_activ varchar2(30).
ALTER TABLE RusuIulian_Active ADD (Descriere_activ varchar2(20));

--3) Sa se stearga coloana Descriere_activ.
ALTER TABLE RusuIulian_Active DROP COLUMN Descriere_activ;

--4) Sa se adauge restrictie pentru coloana AMORTIZARE care sa permita doar introducerea valorilor 'Da' si 'Nu'.
ALTER TABLE RusuIulian_Active ADD CONSTRAINT ck_amortizare CHECK (Amortizare in ('Da', 'Nu'));

/*c) Capitaluri_proprii
- Nume coloana          ID_capital       Tip_capital    Denumire_capital    Data_adaugare     Valoare_capital              CUI
- Tipul Restrictiei    Primary key                                                                                 Foreign Key- Referinta Tabela Societati, coloana CUI
- Tip data             Number             Varchar2         Varchar2          Date                 Number                  Number
-Lungime                 5                   20               30                                    10                      8
*/
CREATE TABLE RusuIulian_Capitaluri_proprii
(Id_capital number(5) primary key,
Tip_capital varchar2(20),
Denumire_capital varchar2(30),
Data_adaugare date,
Valoare_capital number(10),
CUI number(8),
Constraint FK_CUI_CP FOREIGN KEY (CUI) REFERENCES RusuIulian_Societati (CUI)
);

-- d) Sa se creeze tabela Datorii folosind structura tabelei CAPITALURI_PROPRII. 
CREATE TABLE RusuIulian_Datorii
AS SELECT * FROM RusuIulian_Capitaluri_proprii
WHERE 1=2;

-- 5) Sa se redenumeasca coloanele adaugate si sa se adauge restrictiile necesare.
ALTER TABLE RusuIulian_Datorii Rename Column Id_capital to Id_datorie;
ALTER TABLE RusuIulian_Datorii Rename Column Tip_capital to Tip_datorie;
ALTER TABLE RusuIulian_Datorii Rename Column Denumire_capital to Denumire_datorie;
ALTER TABLE RusuIulian_Datorii Rename Column Valoare_capital to Valoare_datorie;
ALTER TABLE RusuIulian_Datorii ADD Constraint PK_Id_datorie PRIMARY KEY (Id_datorie);
ALTER TABLE RusuIulian_Datorii ADD Constraint FK_CUI_D FOREIGN KEY (CUI) REFERENCES RusuIulian_Societati (CUI);

-- e)* Sa se creeze tabela Venituri preluand coloanele Data_adaugare si CUI din tabela Datorii si sa se adauge restul coloanelor + restrictii separat
CREATE TABLE RusuIulian_Venituri
AS SELECT Data_adaugare, CUI FROM RusuIulian_Datorii;
ALTER TABLE RusuIulian_Venituri ADD(Id_venit number(5) primary key,
Tip_venit varchar2(20),
Denumire_venit varchar2(30),
Valoare_venit number(10));
ALTER TABLE RusuIulian_Venituri ADD Constraint FK_CUI_V FOREIGN KEY (CUI) REFERENCES RusuIulian_Societati (CUI);

-- 6) Sa se redenumeasca tabela Venituri in Venituri2.
ALTER TABLE RusuIulian_Venituri RENAME to RusuIulian_Venituri2;

-- 7) Sa se stearga tabela Venituri2 ca nu imi place cum arata.
DROP TABLE RusuIulian_Venituri2 PURGE;

/* e) Venituri
- Nume coloana          ID_venit       Tip_venit    Denumire_venit    Data_adaugare     Valoare_venit              CUI
- Tipul Restrictiei      Primary key                                                                          Foreign Key- Referinta Tabela Societati, coloana CUI
- Tip data                 Number      Varchar2        Varchar2            Date             Number                  Number
-Lungime                        5          20             30                                  10                      8
*/
CREATE TABLE RusuIulian_Venituri
(Id_venit number(5) primary key,
Tip_venit varchar2(20),
Denumire_venit varchar2(30),
Data_adaugare date,
Valoare_venit number(10),
CUI number(8),
Constraint FK_CUI_V FOREIGN KEY (CUI) REFERENCES RusuIulian_Societati (CUI)
);

/*f) Cheltuieli
- Nume coloana          ID_cheltuiala       Tip_cheltuiala    Denumire_cheltuiala    Data_adaugare     Valoare_cheltuiala              CUI
- Tipul Restrictiei      Primary key                                                                                         Foreign Key- Referinta Tabela Societati, coloana CUI
- Tip data                 Number             Varchar2         Varchar2                 Date                 Number                  Number
-Lungime                        5                   20               30                                      10                      8
*/
CREATE TABLE RusuIulian_Cheltuieli
(Id_cheltuiala number(5) primary key,
Tip_cheltuiala varchar2(30),
Denumire_cheltuiala varchar2(30),
Data_adaugare date,
Valoare_cheltuiala number(10),
CUI number(8),
Constraint FK_CUI_CH FOREIGN KEY (CUI) REFERENCES RusuIulian_Societati (CUI)
);

-- 8) Sa se modifice  proprietatea campului Id_cheltuiala astfel incat sa aiba lungimea de 7.
ALTER TABLE RusuIulian_Cheltuieli MODIFY(Id_cheltuiala number(7));

--II.
-- 1) Sa se adauge valori in toate tabelele create.
-- a) SOCIETATI
INSERT INTO RusuIulian_Societati VALUES (90,'SA','RusuIulian','Mangalia','(+40)723-160-475');
INSERT INTO RusuIulian_Societati VALUES (91,'SRL','SweetFlori','Constanta','(+40)745-678-940');
INSERT INTO RusuIulian_Societati VALUES (92,'SNC','Termopane','Cluj-Napoca','(+40)728-783-703');
INSERT INTO RusuIulian_Societati VALUES (93,'SA','PureSoftware','Bucuresti','(+40)758-241-541');
INSERT INTO RusuIulian_Societati VALUES (94,'SA','Ubisoft','Constanta','(+40)723-160-475');
INSERT INTO RusuIulian_Societati VALUES (95,'SNC','Electronic','Bucuresti','(+40)728-783-703');
INSERT INTO RusuIulian_Societati VALUES (96,'SRL','Activision','Segarcea','(+40)744-481-304');
INSERT INTO RusuIulian_Societati VALUES (97,'SRL','Deloat','Bucuresti','(+40)745-607-086');
INSERT INTO RusuIulian_Societati VALUES (98,'SA','CrisTIm','Bucuresti','(+40)741-409-278');
INSERT INTO RusuIulian_Societati VALUES (99,'SA','Lidl','Iasi','(+40)745-546-896');

--2) Sa se modifice Tip_societate in 'SRL' societatii cu CUI=90.
UPDATE RusuIulian_Societati SET Tip_societate='SRL'
WHERE CUI=90;

-- b) ACTIVE
INSERT INTO RusuIulian_Active VALUES (10,'Stocuri','Marfuri',TO_DATE('21-12-2019','DD-MM-YYYY'),20000,'Nu',NULL,99);
INSERT INTO RusuIulian_Active VALUES (11,'Imobilizari_necorporale','Licente',TO_DATE('17-08-2021','DD-MM-YYYY'),4000,'Da',100,93);
INSERT INTO RusuIulian_Active VALUES (12,'Imobilizari_corporale','Cladiri',TO_DATE('02-01-2020','DD-MM-YYYY'),114500,'Da',2500,95);
INSERT INTO RusuIulian_Active VALUES (13,'Creante','Clienti',TO_DATE('21-12-2019','DD-MM-YYYY'),15000,'Nu',NULL,91);
INSERT INTO RusuIulian_Active VALUES (14,'Casa_conturi','Numerar',TO_DATE('15-10-2019','DD-MM-YYYY'),20000,'Nu',NULL,90);
INSERT INTO RusuIulian_Active VALUES (15,'Imobilizari_corporale','Utilaje',TO_DATE('02-04-2021','DD-MM-YYYY'),75000,'Da',1300,98);
INSERT INTO RusuIulian_Active VALUES (16,'Stocuri','Materii_prime',TO_DATE('05-11-2019','DD-MM-YYYY'),15000,'Nu',NULL,91);
INSERT INTO RusuIulian_Active VALUES (17,'Imobilizari_necorporale','Concesiuni',TO_DATE('29-03-2018','DD-MM-YYYY'),40000,'Da',4000,92);
INSERT INTO RusuIulian_Active VALUES (18,'Casa_conturi','Disponibil_bancar',TO_DATE('18-05-2021','DD-MM-YYYY'),12000,'Nu',NULL,96);
INSERT INTO RusuIulian_Active VALUES (19,'Creante','Clienti',TO_DATE('09-09-2020','DD-MM-YYYY'),6000,'Nu',NULL,90);
INSERT INTO RusuIulian_Active VALUES (20,'Stocuri','Produse_finite',TO_DATE('20-10-2021','DD-MM-YYYY'),78900,'Nu',NULL,99);
INSERT INTO RusuIulian_Active VALUES (21,'Imobilizari_corporale','Tereneuri',TO_DATE('01-01-2019','DD-MM-YYYY'),105000,'Nu',NULL,97);
INSERT INTO RusuIulian_Active VALUES (22,'Creante','Debitori',TO_DATE('17-10-2018','DD-MM-YYYY'),87500,'Nu',NULL,94);
INSERT INTO RusuIulian_Active VALUES (23,'Casa_conturi','Acreditive',TO_DATE('07-03-2021','DD-MM-YYYY'),12500,'Nu',NULL,92);
INSERT INTO RusuIulian_Active VALUES (24,'Imobilizari_corporale','Cladiri',TO_DATE('13-09-2019','DD-MM-YYYY'),91000,'Da',1250,90);
INSERT INTO RusuIulian_Active VALUES (25,'Stocuri','Marfuri',TO_DATE('25-10-2020','DD-MM-YYYY'),22250,'Nu',NULL,90);
INSERT INTO RusuIulian_Active VALUES (26,'Imobilizari_corporale','Terenuri',TO_DATE('03-02-2019','DD-MM-YYYY'),64900,'Nu',NULL,91);
INSERT INTO RusuIulian_Active VALUES (27,'Casa_conturi','Disponibil_bancar',TO_DATE('15-10-2021','DD-MM-YYYY'),28520,'Nu',NULL,92);
INSERT INTO RusuIulian_Active VALUES (28,'Imobilizari_corporale','Terenuri',TO_DATE('01-04-2018','DD-MM-YYYY'),70450,'Nu',NULL,93);
INSERT INTO RusuIulian_Active VALUES (29,'Imobilizari_corporale','Cladiri',TO_DATE('29-10-2019','DD-MM-YYYY'),61500,'Da',2500,96);

--3) S-a notat gresit data Activei cu ID-ul 13. Sa se modifice data acesteia.
UPDATE RusuIulian_Active SET Data_adaugare=TO_DATE('21-12-2018','DD-MM-YYYY')
WHERE Id_activ=13;

--4)Sa se stearga Creantele din anul 2020
DELETE FROM RusuIulian_Active
WHERE UPPER(Tip_activ)='CREANTE' AND Extract(YEAR FROM Data_adaugare)=2020;

--5) Sa se modifice Activele care au amortizari anuale ( Din valoarea lor se scade valoarea amortizarii pe 1 an)
Select * FROM RusuIulian_Active
WHERE Amortizare='Da';
UPDATE RusuIulian_Active SET Valoare_activ=Valoare_activ+Valoare_amortizare
WHERE Amortizare='Da';


-- c)CAPITALURI PROPRII
INSERT INTO RusuIulian_Capitaluri_proprii VALUES (30,'Capital_subscris','Capital_subscris_varsat',TO_DATE('01-01-2018','DD-MM-YYYY'),62000,96);
INSERT INTO RusuIulian_Capitaluri_proprii VALUES (31,'Rezerve','Rezerve_legale',TO_DATE('28-12-2020','DD-MM-YYYY'),40000,90);
INSERT INTO RusuIulian_Capitaluri_proprii VALUES (32,'Rezerve','Rezerve_reevaluare',TO_DATE('15-06-2019','DD-MM-YYYY'),6770,98);
INSERT INTO RusuIulian_Capitaluri_proprii VALUES (33,'Prime','Prime_emisiune',TO_DATE('04-10-2019','DD-MM-YYYY'),5500,99);
INSERT INTO RusuIulian_Capitaluri_proprii VALUES (34,'Capital_subscris','Capital_subscris_nevarsat',TO_DATE('04-10-2021','DD-MM-YYYY'),60000,94);

/* 6) a) A intervenit o problema tehnica si s-au pierdut datele tabelei CAPITALURI PROPRII. Pana sa recupereaza datele sa se creeze o tabela CP
cu aceeasi structura. */
CREATE TABLE RusuIulian_CP AS
SELECT * FROM RusuIulian_Capitaluri_proprii
WHERE 1=2;
-- b) Sa se introduca date in aceasta tabela
INSERT INTO RusuIulian_CP VALUES (35,'Capital_subscris','Capital_subscris_varsat',TO_DATE('01-07-2020','DD-MM-YYYY'),98000,99);
INSERT INTO RusuIulian_CP VALUES (36,'Capital_subscris','Capital_subscris_varsat',TO_DATE('09-09-2018','DD-MM-YYYY'),95000,95);
INSERT INTO RusuIulian_CP VALUES (37,'Prime','Prime_aport',TO_DATE('30-11-2019','DD-MM-YYYY'),7500,96);
INSERT INTO RusuIulian_CP VALUES (38,'Rezerve','Rezerve_statuare',TO_DATE('27-07-2021','DD-MM-YYYY'),3200,92);
INSERT INTO RusuIulian_CP VALUES (39,'Capital_subscris','Capital_subscris_varsat',TO_DATE('01-01-2019','DD-MM-YYYY'),44000,92);
INSERT INTO RusuIulian_CP VALUES (40,'Capital_subscris','Capital_subscris_nevarsat',TO_DATE('03-05-2021','DD-MM-YYYY'),12800,92);
INSERT INTO RusuIulian_CP VALUES (41,'Prime','Prime_emisiune',TO_DATE('12-08-2020','DD-MM-YYYY'),10000,91);
INSERT INTO RusuIulian_CP VALUES (42,'Capital_subscris','Capital_subscris_varsat',TO_DATE('17-02-2018','DD-MM-YYYY'),57500,98);
INSERT INTO RusuIulian_CP VALUES (43,'Capital_subscris','Capital_subscris_nevarsat',TO_DATE('22-10-2021','DD-MM-YYYY'),92000,90);
INSERT INTO RusuIulian_CP VALUES (44,'Capital_subscris','Capital_subscris_varsat',TO_DATE('17-04-2020','DD-MM-YYYY'),75000,97);
INSERT INTO RusuIulian_CP VALUES (45,'Capital_subscris','Capital_subscris_nevarsat',TO_DATE('29-03-2018','DD-MM-YYYY'),34500,91);
INSERT INTO RusuIulian_CP VALUES (46,'Capital_subscris','Capital_subscris_nevarsat',TO_DATE('11-11-2021','DD-MM-YYYY'),41000,93);

-- c) S-au recuperat datele tabelei CAPITALURI PROPRII. Sa se concateneze cele 2 tabele.
MERGE INTO RusuIulian_Capitaluri_proprii cp
USING (SELECT * FROM RusuIulian_CP) rcp
ON (cp.Id_capital=rcp.Id_capital)
WHEN MATCHED THEN UPDATE SET cp.Valoare_capital=cp.Valoare_capital+rcp.Valoare_capital
WHEN NOT MATCHED THEN INSERT (cp.ID_CAPITAL,cp.TIP_CAPITAL,cp.DENUMIRE_CAPITAL,cp.DATA_ADAUGARE,cp.VALOARE_CAPITAL,cp.CUI) 
VALUES (rcp.ID_CAPITAL,rcp.TIP_CAPITAL,rcp.DENUMIRE_CAPITAL,rcp.DATA_ADAUGARE,rcp.VALOARE_CAPITAL,rcp.CUI);
DROP TABLE RusuIulian_CP PURGE;

--7) S-a varsat capitalul in societatile care aveau Capital subscris nevarsat, mai putin societatii cu id 92. Sa se modifice Denumirea.
SELECT * FROM RusuIulian_Capitaluri_proprii
WHERE Denumire_capital='Capital_subscris_nevarsat' AND CUI!=92;
UPDATE RusuIulian_Capitaluri_proprii SET Denumire_capital='Capital_subscris_varsat'
WHERE Denumire_capital='Capital_subscris_nevarsat' AND CUI!=92;

--8) Pentru societatea 92, sa se verse Capitalul si sa se stearga Inregistrarea cu Capitalul subscris nevarsat.
SELECT * FROM RusuIulian_Capitaluri_proprii
WHERE CUI=92;
UPDATE RusuIulian_Capitaluri_proprii SET Valoare_capital=Valoare_capital+(SELECT Valoare_capital FROM RusuIulian_Capitaluri_proprii WHERE CUI=92 AND Denumire_capital='Capital_subscris_nevarsat')
WHERE Id_capital=39;
DELETE FROM RusuIulian_Capitaluri_proprii
WHERE Id_capital=40;

-- d) DATORII
INSERT INTO RusuIulian_Datorii VALUES (50,'Datorii_curente','Dobanzi_datorate',TO_DATE('17-11-2021','DD-MM-YYYY'),16000,91);
INSERT INTO RusuIulian_Datorii VALUES (51,'Datorii_curente','Datorii_furnizori',TO_DATE('18-01-2021','DD-MM-YYYY'),2400,99);
INSERT INTO RusuIulian_Datorii VALUES (52,'Datorii_necurente','Credite_bancare_TL',TO_DATE('16-12-2020','DD-MM-YYYY'),14800,92);
INSERT INTO RusuIulian_Datorii VALUES (53,'Datorii_necurente','Imprumuturi_TL',TO_DATE('28-07-2019','DD-MM-YYYY'),32000,91);
INSERT INTO RusuIulian_Datorii VALUES (54,'Datorii_curente','Salarii_datorate',TO_DATE('15-05-2021','DD-MM-YYYY'),12000,93);
INSERT INTO RusuIulian_Datorii VALUES (55,'Datorii_curente','Credite_bancare_TS',TO_DATE('24-03-2021','DD-MM-YYYY'),5500,97);
INSERT INTO RusuIulian_Datorii VALUES (56,'Datorii_curente','Imprumuturi_TS',TO_DATE('07-04-2021','DD-MM-YYYY'),8200,98);
INSERT INTO RusuIulian_Datorii VALUES (57,'Datorii_curente','Salarii_datorate',TO_DATE('27-02-2021','DD-MM-YYYY'),17000,95);
INSERT INTO RusuIulian_Datorii VALUES (58,'Datorii_curente','Datorii_actionari',TO_DATE('10-12-2021','DD-MM-YYYY'),17700,94);
INSERT INTO RusuIulian_Datorii VALUES (59,'Datorii_necurente','Credite_bancare_TL',TO_DATE('01-06-2020','DD-MM-YYYY'),17000,93);
INSERT INTO RusuIulian_Datorii VALUES (60,'Datorii_curente','Datorii_dividende',TO_DATE('17-11-2021','DD-MM-YYYY'),1500,96);
INSERT INTO RusuIulian_Datorii VALUES (61,'Datorii_curente','Datorii_furnizori',TO_DATE('05-05-2021','DD-MM-YYYY'),7145,94);
INSERT INTO RusuIulian_Datorii VALUES (62,'Datorii_necurente','Credite_bancare_TL',TO_DATE('24-03-2018','DD-MM-YYYY'),24500,97);
update RusuIulian_Datorii set data_adaugare=TO_DATE('05-05-2021','DD-MM-YYYY') where id_datorie=61;
--9) Sa se mareasca datoriile cu 15% care sunt de maxim 2 ani vechime.
SELECT * FROM RusuIulian_Datorii WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM Data_adaugare) <= 2; 
UPDATE RusuIulian_Datorii SET Valoare_datorie=Valoare_datorie*1.15
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM Data_adaugare) <= 2;

-- e) VENITURI
INSERT INTO RusuIulian_Venituri VALUES (70,'Venituri_exploatare','Vanzare_marfuri',TO_DATE('17-12-2021','DD-MM-YYYY'),300000,92);
INSERT INTO RusuIulian_Venituri VALUES (71,'Venituri_exploatare','Venituri_chirii',TO_DATE('12-08-2021','DD-MM-YYYY'),36000,97);
INSERT INTO RusuIulian_Venituri VALUES (72,'Venituri_financiare','Venituri_dividende',TO_DATE('07-09-2021','DD-MM-YYYY'),12500,98);
INSERT INTO RusuIulian_Venituri VALUES (73,'Venituri_exploatare','Venituri_cedarea_activelor',TO_DATE('17-12-2020','DD-MM-YYYY'),45000,96);
INSERT INTO RusuIulian_Venituri VALUES (74,'Venituri_financiare','Vanzare_imob_financiare',TO_DATE('12-04-2020','DD-MM-YYYY'),14000,98);
INSERT INTO RusuIulian_Venituri VALUES (75,'Venituri_financiare','Castig_cedare_inv_TS',TO_DATE('03-09-2020','DD-MM-YYYY'),2500,91);
INSERT INTO RusuIulian_Venituri VALUES (76,'Venituri_exploatare','Venituri_chirii',TO_DATE('28-08-2020','DD-MM-YYYY'),14700,92);
INSERT INTO RusuIulian_Venituri VALUES (77,'Venituri_exploatare','Vanzare_marfuri',TO_DATE('24-02-2021','DD-MM-YYYY'),180000,93);
INSERT INTO RusuIulian_Venituri VALUES (78,'Venituri_financiare','Vanzare_imob_financiare',TO_DATE('12-06-2020','DD-MM-YYYY'),24500,95);
INSERT INTO RusuIulian_Venituri VALUES (79,'Venituri_exploatare','Venituri_chirii',TO_DATE('22-08-2021','DD-MM-YYYY'),15000,90);
INSERT INTO RusuIulian_Venituri VALUES (80,'Venituri_exploatare','Venituri_chirii',TO_DATE('08-05-2021','DD-MM-YYYY'),21000,91);
INSERT INTO RusuIulian_Venituri VALUES (81,'Venituri_financiare','Castig_cedare_inv_TS',TO_DATE('20-05-2021','DD-MM-YYYY'),7800,99);
INSERT INTO RusuIulian_Venituri VALUES (82,'Venituri_financiare','Vanzare_imob_financiare',TO_DATE('16-07-2021','DD-MM-YYYY'),11000,94);
INSERT INTO RusuIulian_Venituri VALUES (83,'Venituri_exploatare','Vanzare_marfuri',TO_DATE('15-12-2021','DD-MM-YYYY'),294000,91);

-- f) CHELTUIELI
INSERT INTO RusuIulian_Cheltuieli VALUES(900,'Cheltuieli_exploatare','Cheltuieli_marfuri',TO_DATE('05-03-2021','DD-MM-YYYY'),250000,90);
INSERT INTO RusuIulian_Cheltuieli VALUES(901,'Cheltuieli_financiare','Cheltuieli_dobanzi',TO_DATE('10-03-2021','DD-MM-YYYY'),4000,94);
INSERT INTO RusuIulian_Cheltuieli VALUES(902,'Cheltuieli_exploatare','Cheltuieli_materiale_cons',TO_DATE('30-08-2020','DD-MM-YYYY'),5000,93);
INSERT INTO RusuIulian_Cheltuieli VALUES(903,'Cheltuieli_exploatare','Cheltuieli_energie_electrica',TO_DATE('30-10-2021','DD-MM-YYYY'),3000,93);
INSERT INTO RusuIulian_Cheltuieli VALUES(904,'Cheltuieli_exploatare','Cheltuieli_salarii',TO_DATE('09-01-2020','DD-MM-YYYY'),30000,96);
INSERT INTO RusuIulian_Cheltuieli VALUES(905,'Cheltuieli_financiare','Cheltuieli_inv_TS',TO_DATE('25-07-2021','DD-MM-YYYY'),12000,97);
INSERT INTO RusuIulian_Cheltuieli VALUES(906,'Cheltuieli_exploatare','Cheltuieli_amortizari',TO_DATE('19-05-2021','DD-MM-YYYY'),2500,95);
INSERT INTO RusuIulian_Cheltuieli VALUES(907,'Cheltuieli_financiare','Cheltuieli_inv_TS',TO_DATE('10-09-2020','DD-MM-YYYY'),24000,98);
INSERT INTO RusuIulian_Cheltuieli VALUES(908,'Cheltuieli_exploatare','Cheltuieli_comisioane',TO_DATE('22-03-2021','DD-MM-YYYY'),8200,99);
INSERT INTO RusuIulian_Cheltuieli VALUES(909,'Cheltuieli_financiare','Cheltuieli_dobanzi',TO_DATE('14-06-2021','DD-MM-YYYY'),5500,96);
INSERT INTO RusuIulian_Cheltuieli VALUES(910,'Cheltuieli_exploatare','Cheltuieli_taxe',TO_DATE('10-10-2020','DD-MM-YYYY'),4200,95);
INSERT INTO RusuIulian_Cheltuieli VALUES(911,'Cheltuieli_financiare','Cheltuieli_cedarea_activelor',TO_DATE('17-12-2020','DD-MM-YYYY'),34000,96);
INSERT INTO RusuIulian_Cheltuieli VALUES(912,'Cheltuieli_financiare','Cheltuieli_dobanzi',TO_DATE('17-04-2020','DD-MM-YYYY'),6100,91);
INSERT INTO RusuIulian_Cheltuieli VALUES(913,'Cheltuieli_exploatare','Cheltuieli_impozite',TO_DATE('22-09-2020','DD-MM-YYYY'),2400,91);
INSERT INTO RusuIulian_Cheltuieli VALUES(914,'Cheltuieli_exploatare','Cheltuieli_amortizari',TO_DATE('09-10-2021','DD-MM-YYYY'),1300,98);
INSERT INTO RusuIulian_Cheltuieli VALUES(915,'Cheltuieli_exploatare','Cheltuieli_amortizari',TO_DATE('27-07-2020','DD-MM-YYYY'),4000,92);
INSERT INTO RusuIulian_Cheltuieli VALUES(916,'Cheltuieli_exploatare','Cheltuieli_amortizari',TO_DATE('19-01-2020','DD-MM-YYYY'),2500,90);

-- 10) Sa se miscosereze cheltuielile societatilor 91 si 93 cu 5%
SELECT * FROM RusuIulian_Cheltuieli WHERE CUI IN (91,93);
UPDATE RusuIulian_Cheltuieli SET Valoare_cheltuiala=Valoare_cheltuiala/0.95
WHERE CUI IN (91,93);

-- III
-- 1) Sa se afiseze societatea din localitatea Iasi si activele acesteia
SELECT s.CUI,Tip_societate,Denumire_societate,Localitate,Telefon,Id_activ,Tip_activ,Denumire_activ,Valoare_activ 
FROM RusuIulian_Societati s,RusuIulian_Active a
WHERE s.CUI=a.CUI AND UPPER(LOCALITATE)='IASI';

-- 2) Sa se afiseze cate Active imobilizate(Imobilizari necorporale, corporale, financiare) sunt in baza de date
SELECT COUNT(ID_ACTIV) Numar_active_Imobilizate
FROM RusuIulian_Active
WHERE Tip_activ LIKE 'Imobilizari%';

-- 3) Sa se afiseze societatile care nu au datorii in bilant
SELECT CUI,Tip_societate,Denumire_societate
FROM RusuIulian_Societati
MINUS
SELECT s.CUI,Tip_societate,Denumire_societate
FROM RusuIulian_Societati s, RusuIulian_Datorii d
WHERE s.CUI=d.CUI;

-- 4) Sa se afiseze o descriere a societatii 97
SELECT 'Societatea ' || Denumire_societate || ' ' || Tip_societate || ' cu codul unic ' || CUI || ' are sediul in localitatea ' || Localitate || ' si are numarul de telefon '|| Telefon || '.' Descriere
FROM RusuIulian_Societati
WHERE CUI=97;

-- 5) Sa se afiseze Societatile care au sediul in orasele care incep cu litera C
SELECT *
FROM RusuIulian_Societati
WHERE SUBSTR(Localitate,1,1)='C';

-- 6) Sa se afiseze suma Datoriilor pe termen scurt (TS)
SELECT Id_datorie,Valoare_datorie
FROM RusuIulian_Datorii
WHERE ROUND(MONTHS_BETWEEN(To_date('01-01-2022','DD-MM-YYYY'),Data_adaugare))<=12 AND Denumire_datorie NOT LIKE '%TL';

SELECT SUM(Valoare_datorie) Total_datorii_TS
FROM RusuIulian_Datorii
WHERE ROUND(MONTHS_BETWEEN(To_date('01-01-2022','DD-MM-YYYY'),Data_adaugare))<=12 AND Denumire_datorie NOT LIKE '%TL';

--VARIANTA MAI USOARA
SELECT SUM(Valoare_datorie) Total_datorii_TS
FROM RusuIulian_Datorii
WHERE Tip_datorie='Datorii_curente';

-- 7) Sa se afiseze valoarea minima, medie si maxima a veniturilor financiare din cont
SELECT MIN(Valoare_venit) Valoare_min_venit_financiar,AVG(Valoare_venit) Valoare_medie_venit_financiar,MAX(Valoare_venit) Valoare_max_venit_financiar
FROM RusuIulian_Venituri
WHERE LOWER(Tip_venit) LIKE '%financiare';

-- 8) Sa se ordoneze societatile dupa totalul capitalului propriu al fiecareia
SELECT s.CUI, Denumire_societate, SUM(Valoare_capital) Total_capital
FROM RusuIulian_Societati s, RusuIulian_Capitaluri_Proprii cp
WHERE s.CUI=cp.CUI
GROUP BY s.CUI, Denumire_societate
ORDER BY Total_capital;

-- 9) Sa se afiseze societatile care au minim 3 venituri in cont
SELECT s.CUI, Denumire_societate, COUNT(Id_venit) Numar_venituri
FROM RusuIulian_Societati s, RusuIulian_Venituri v
WHERE s.CUI=v.CUI
GROUP BY s.CUI, Denumire_societate
HAVING COUNT(Id_venit)>=3;

-- 10) Sa se calculeze totalul cheltuielilor de exploatare din anul 2020
SELECT *
FROM  RusuIulian_Cheltuieli
WHERE LOWER(Tip_cheltuiala)='cheltuieli_exploatare' AND EXTRACT(Year FROM Data_adaugare)=2020;

SELECT SUM(Valoare_cheltuiala) Tota_chelt_exploatare
FROM  RusuIulian_Cheltuieli
WHERE LOWER(Tip_cheltuiala)='cheltuieli_exploatare' AND EXTRACT(Year FROM Data_adaugare)=2020;

-- 11) Sa se afiseze datoriile adaugate intre 10 februarie 2019 si 10 august 2019 (to char)
SELECT Id_datorie,Denumire_datorie, TO_CHAR(Data_adaugare,'DD Mon,YYYY') Data_adaugare, Valoare_datorie, CUI
FROM RusuIulian_Datorii
WHERE Data_adaugare BETWEEN TO_DATE('10-02-2019','DD-MM-YYYY') AND TO_DATE('01-08-2019','DD-MM-YYYY');

-- 12) Sa se afiseze societatile in ordine descrescatoare care au suma activelor circulante (Stocuri+ Creante + Casa si conturi la banci) mai mare decat 50000
SELECT s.CUI, Denumire_societate,SUM(Valoare_activ) Val_totala_active_circulante
FROM RusuIulian_Societati s, RusuIulian_Active a
WHERE s.CUI=a.CUI AND UPPER(Tip_activ) IN ('STOCURI', 'CREANTE', 'CASA_CONTURI')
GROUP BY s.CUI, Denumire_societate
HAVING SUM(Valoare_activ) > 50000
ORDER BY Val_totala_active_circulante desc;

/* 13) Societatea 94 a cumparat un utilaj in valoare de 16000 RON cu o amortizare anuala de 200 RON fara decontare imediata la data de 17 noiembrie 2021. Sa se adauge modificarile in bilantul societatii */
--Se introduce Utilajul la Active
INSERT INTO RusuIulian_active VALUES(101,'Imobilizari_corporale', 'Utilaje', TO_DATE('17-11-2021','DD-MM-YYYY'),16000,'Da',200,94);
SELECT * FROM RusuIulian_active WHERE ID_activ=101;

--Nefiind decontare imediata se introduce datoria fata de furnizor la Datorii
INSERT INTO RusuIulian_datorii VALUES(501,'Datorii_curente','Datorii_furnizori',TO_DATE('17-11-2021','DD-MM-YYYY'),16000,94);
SELECT * FROM RusuIulian_datorii WHERE ID_datorie=501;

--Se afiseaza modificarile in bilantul societatii
SELECT * 
FROM RusuIulian_active a, RusuIulian_datorii d
WHERE a.CUI=d.CUI AND ID_activ=101 AND ID_datorie=501;

/* 14) Sa se mareasca capitalul social(subscris varsat) astfel:
1. Daca este intre 0 si 34999, se va mari cu 10%
2. Daca este intre 35000 si 49999, se va mari cu 5%
3. Daca este intre 50000 si 64999, se va mari cu 2%
4. Daca este minim 65000, nu se va mari */
--Variante cu CASE
Select CUI, Id_capital, Denumire_capital,Valoare_capital,
CASE WHEN Valoare_capital <=34999 THEN Valoare_capital*1.1
WHEN Valoare_capital BETWEEN 35000 AND 49999 THEN Valoare_capital*1.05
WHEN Valoare_capital BETWEEN 50000 AND 64999 THEN Valoare_capital*1.02
WHEN Valoare_capital >= 65000 THEN Valoare_capital
END Noua_valoare
FROM RusuIulian_Capitaluri_Proprii
WHERE Denumire_capital LIKE '%varsat'
ORDER BY Valoare_capital;

/*15) Sa se afiseze urmatoarele active:
1. Daca anul in care au fost adaugate este 2019, sa se afiseze cea mai mica valoare a activelor
2. Daca anul in care au fost adaugate este 2020, sa se afiseze valoarea medie a activelor
3. Daca anul in care au fost adaugate este 2021, sa se afiseze cea mai mare valoare a activelor */
SELECT EXTRACT(Year FROM Data_adaugare) An,
DECODE(EXTRACT(Year FROM Data_adaugare),2019,MIN(Valoare_activ),2020,AVG(Valoare_activ),2021,MAX(Valoare_activ)) Valoare
FROM RusuIulian_Active
WHERE EXTRACT(Year FROM Data_adaugare)>2018
GROUP BY EXTRACT(Year FROM Data_adaugare)
ORDER BY An;

-- 16) Sa se afiseze Numele si activele societatilor de la 93 la 96, mai putin cele din societatea 95
SELECT s.CUI,Denumire_societate,Id_activ,Tip_activ,Denumire_activ,Valoare_activ 
FROM RusuIulian_Societati s,RusuIulian_Active a
WHERE s.CUI=a.CUI AND s.CUI BETWEEN 93 AND 96
MINUS
SELECT s.CUI,Denumire_societate,Id_activ,Tip_activ,Denumire_activ,Valoare_activ 
FROM RusuIulian_Societati s,RusuIulian_Active a
WHERE s.CUI=a.CUI AND s.CUI=95;

-- 17) Sa se afiseze societatile de tipul "SRL" si care au totalul cheltuielilor maxim 35000
SELECT s.CUI,Denumire_societate, SUM(Valoare_cheltuiala) Total_cheltuieli
FROM RusuIulian_Societati s, RusuIulian_Cheltuieli ch
WHERE s.CUI=ch.CUI AND Tip_societate='SRL'
GROUP BY s.CUI,Denumire_societate
INTERSECT
SELECT s.CUI,Denumire_societate, SUM(Valoare_cheltuiala)
FROM RusuIulian_Societati s, RusuIulian_Cheltuieli ch
WHERE s.CUI=ch.CUI
GROUP BY s.CUI,Denumire_societate
HAVING SUM(Valoare_cheltuiala)<35000;

-- 18) Sa se afiseze societatile care o activa sau mai mult de 2 datorii
SELECT s.CUI, Denumire_societate,COUNT(Id_activ) Numar
FROM RusuIulian_Societati s,RusuIulian_Active a
WHERE s.CUI=a.CUI
GROUP BY s.CUI, Denumire_societate
HAVING COUNT(Id_activ)=1
UNION 
SELECT s.CUI, Denumire_societate,COUNT(Id_datorie) Numar
FROM RusuIulian_Societati s,RusuIulian_Datorii d 
WHERE s.CUI=d.CUI
GROUP BY s.CUI, Denumire_societate
HAVING COUNT(Id_datorie)>2;

-- 19) Sa se afiseze rezultatul exercitiului(Total venituri-Total cheltuieli) pentru societatile din Bucuresti, ordonat crescator.
SELECT s.CUI, Denumire_societate, SUM(Valoare_venit)-SUM(Valoare_cheltuiala) Rezultatul_exercitiului
FROM RusuIulian_Societati s, RusuIulian_Venituri v, RusuIulian_Cheltuieli ch
WHERE s.CUI=v.CUI AND v.CUI=ch.CUI AND LOWER(Localitate)='bucuresti'
GROUP BY s.CUI, Denumire_societate
ORDER BY Rezultatul_exercitiului;

-- 20) Societatea 99 a vandut marfuri in valoare de 12000 cu incasare imediata in data de 27 noiembrie 2022 . Sa se efectueze modificarile ulterior vanzarii
-- a) Vanzarea propriu-zisa: crestere disponibil, crestere venituri din vanzarea marfurilor
INSERT INTO RusuIulian_Active VALUES(102,'Casa_conturi','Disponibil_bancar',TO_DATE('27-11-2022','DD-MM-YYYY'),12000,'Da',NULL,99);
INSERT INTO RusuIulian_Venituri VALUES(702,'Venituri_exploatare','Venituri_chirii',TO_DATE('27-11-2022','DD-MM-YYYY'),12000,99);

--b) Descarcarea de gestiune: scadere marfuri si crestere cheltuieli
UPDATE RusuIulian_Active SET Valoare_activ=Valoare_activ-12000, Data_adaugare=TO_DATE('27-11-2022','DD-MM-YYYY')
WHERE Id_activ=10;
INSERT INTO RusuIulian_cheltuieli VALUES(9022,'Cheltuieli_exploatare','Cheltuieli_marfuri',TO_DATE('27-11-2022','DD-MM-YYYY'),12000,99);

/* 21) Se micsoreaza capitalul social al societatii din Mangalia cu 27000 la data de 28 decembrie 2022. Contravaloarea urmeaza a fi platita ulterior asociatilor. Sa se efectueze modificarea in bilant. */
UPDATE RusuIulian_Capitaluri_proprii SET Valoare_capital=Valoare_capital-27000, Data_adaugare=TO_DATE('28-12-2022','DD-MM-YYYY')
WHERE Id_capital=43;
SELECT * FROM RusuIulian_Datorii WHERE Id_datorie=503;
INSERT INTO RusuIulian_Datorii VALUES(503,'Datorii_curente','Datorii_asociati',TO_DATE('28-12-2022','DD-MM-YYYY'),27000,90);