/*Abfrage 1*/
/*Tabelle mit allen Spielern absteigend nach ihren Fereinsjahren*/
Select CONCAT(Spieler.Nachname, ' ' , Spieler.Vorname) as 'Spieler', DATEDIFF(year,spielt.von, CURRENT_TIMESTAMP) as 'Jahre im Ferein',  DATEDIFF(year,Spieler.Geburtsdatum, CURRENT_TIMESTAMP) as 'Alter', Mannschaft.Klubname as 'Klub'
FROM Mannschaft
join spielt on spielt.fk_MannschaftID = Mannschaft.id
join Spieler on Spieler.id = spielt.fk_SpielerID
Order By 'Jahre im Ferein' desc

/*Abfrage 2*/
/*Tabelle mit allen aktiven Spielern, deren Mannschaften, deren Gesamt Ratings und deren Jahres Lohn.
Absteigend sortiert nach dem Jahreslohn*/
Select  CONCAT(Spieler.Nachname, ' ' , Spieler.Vorname) as 'Spieler', [Fifa Ranking].[Gesamt Rating] as "Spieler Wertung", format(spielt.Lohn, 'C2','de-ch') as "Jährliches Gehalt", Mannschaft.Klubkürzel as "Klub"
From Spieler
join spielt on Spieler.id = spielt.fk_SpielerID
join "Fifa Ranking" on Spieler.id = [Fifa Ranking].fk_SpielerID
join Mannschaft on Mannschaft.id = spielt.fk_MannschaftID
Where spielt.bis > CURRENT_TIMESTAMP
Order By [Fifa Ranking].[Gesamt Rating]  desc

/*Abfrage 3*/
/*Tabelle mit dem Durchschnitt aller Fifa Ranking Gesamt Ratings der Spieler einer Mannschaft*/
Select Mannschaft.Klubname as 'Klub', AVG([Fifa Ranking].[Gesamt Rating]) as "Durchschnittliche Spieler stärke"
From Mannschaft
join spielt on spielt.fk_MannschaftID = Mannschaft.id
join Spieler on Spieler.id = spielt.fk_SpielerID
join "Fifa Ranking" on Spieler.id = [Fifa Ranking].fk_SpielerID
Group by Mannschaft.id, Mannschaft.Klubname
Order By "Durchschnittliche Spieler stärke" asc

/*Abfrage 4*/
/*Lösche Mannschaft Paris Saint-Germain von table Mannschaft*/
alter table spielt nocheck constraint spielt_fk_mannschaftid_foreign
DELETE FROM Mannschaft WHERE Mannschaft.Klubname = 'Paris Saint-Germain';

/*Abfrage 5*/
/*Zähle die Anzahl aktiver Spieler einer Mannschaft.*/
DECLARE @Summe INT = 0;
EXEC @Summe = sp_AnzSpieler 'RMA';
PRINT Concat('In der Mannschaft sind ',@Summe, ' Spieler.');

/*Abfrage 6*/
/*Mit hilfe der Stored Procedure sp_UpsertFifaRanking ein Ranking hinzufügen*/
EXEC sp_UpsertFifaRanking 'Bruno', 'Fernandes', '1994-09-08', 'testversion', 100, 90,80,70,60,50,40

/*Abfrage 7*/
/*Mit hilfe der Stored Procedure sp_UpsertFifaRanking ein Ranking akktualisieren*/
EXEC sp_UpsertFifaRanking 'Bruno', 'Fernandes', '1994-09-08', 'Fifa 22', 100, 90,80,70,60,50,40



