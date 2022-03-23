###Listen af navne, efternavne og titel
$fornavne = Get-Content "C:\Temp\fornavne.txt"
$efternavne = Get-Content "C:\Temp\efternavne.txt"
$titler = Get-Content "C:\Temp\titler.txt"

#Her er der en loop der kører. Skriv antal brugere du gerne vil oprette. I dette tilfælde er det 20 brugere.
$Brugere = for ($num = 1; $num -le 20; $num++)

{


###hent random navn og fornavn
$Fornavn = Get-Random -InputObject $fornavne 
$Efternavn = Get-Random -InputObject $efternavne

###Brugernavn er de to første bogstaver i fornavn og efternavn lagt sammen
$username = $Fornavn.SubString(0,2) + $Efternavn.Substring(0,2)

#Random navn
$Navn = $Fornavn + " " + $Efternavn

#Random titel
$titel = Get-Random -InputObject $titler
 
Write-Host $Navn,$username.ToLower(),$titel 

#Lav nye objecter fra listen som vil blive eksporteret til csv.
New-Object -TypeName PSCustomObject -Property @{

Name = $Navn
samAccountName = $username.ToLower()
titel = $titel
givenName = $Navn





} | Export-Csv C:\Temp\users.csv -Append


} 


#Opret brugerne fra listen
#Du kan ændre om brugerne skal være aktive ved oprettelse og ændre password

Import-Csv "C:\Temp\users.csv" | ForEach-Object {

New-ADUser -SamAccountName $_."samAccountName" -Name $_."Name" -GivenName $_."givenName" -PasswordNeverExpires $false  -AccountPassword (ConvertTo-SecureString "Test12345!" -AsPlainText -Force) -ChangePasswordAtLogon $true -Enabled $true

}




 

  
