/*Tabelle mit allen Spielern absteigend nach ihren Fereinsjahren*/
Select CONCAT(Spieler.Nachname, ' ' , Spieler.Vorname) as 'Spieler', DATEDIFF(year,spielt.von, CURRENT_TIMESTAMP) as 'Jahre im Ferein',  DATEDIFF(year,Spieler.Geburtsdatum, CURRENT_TIMESTAMP) as 'Alter', Mannschaft.Klubname as 'Klub'
FROM Mannschaft
join spielt on spielt.fk_MannschaftID = Mannschaft.id
join Spieler on Spieler.id = spielt.fk_SpielerID
Order By 'Jahre im Ferein' desc

/*Tabelle mit allen aktiven Spielern, deren Mannschaften, deren Gesamt Ratings und deren Jahres Lohn.
Absteigend sortiert nach dem Jahreslohn*/
Select  CONCAT(Spieler.Nachname, ' ' , Spieler.Vorname) as 'Spieler', [Fifa Ranking].[Gesamt Rating] as "Spieler Wertung", format(spielt.Lohn, 'C2','de-ch') as "J�hrliches Gehalt", Mannschaft.Klubk�rzel as "Klub"
From Spieler
join spielt on Spieler.id = spielt.fk_SpielerID
join "Fifa Ranking" on Spieler.id = [Fifa Ranking].fk_SpielerID
join Mannschaft on Mannschaft.id = spielt.fk_MannschaftID
Where spielt.bis > CURRENT_TIMESTAMP
Order By [Fifa Ranking].[Gesamt Rating]  desc


/*Tabelle mit dem Durchschnitt aller Fifa Ranking Gesamt Ratings der Spieler einer Mannschaft*/
Select Mannschaft.Klubname as 'Klub', AVG([Fifa Ranking].[Gesamt Rating]) as "Durchschnittliche Spieler st�rke"
From Mannschaft
join spielt on spielt.fk_MannschaftID = Mannschaft.id
join Spieler on Spieler.id = spielt.fk_SpielerID
join "Fifa Ranking" on Spieler.id = [Fifa Ranking].fk_SpielerID
Group by Mannschaft.id, Mannschaft.Klubname
Order By "Durchschnittliche Spieler st�rke" asc

/*L�sche Mannschaft Paris Saint-Germain von table Mannschaft*/
alter table spielt nocheck constraint spielt_fk_mannschaftid_foreign
DELETE FROM Mannschaft WHERE Mannschaft.Klubname = 'Paris Saint-Germain';

/*Z�hle die Anzahl aktiver Spieler einer Mannschaft.*/
DECLARE @Summe INT = 0;
EXEC @Summe = sp_AnzSpieler 'RMA';
PRINT Concat('In der Mannschaft sind ',@Summe, ' Spieler.');



