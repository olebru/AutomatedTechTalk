function Get-NewPhrase
{
$endpoint = "https://corporatebs-generator.sameerkumar.website/"

$req = Invoke-WebRequest -Uri $endpoint

$res = convertfrom-json -InputObject $req.Content

$res.phrase

}

function Get-PhraseChain
{
    Param
    (
        $length
    )

    $result = "";

    while($length -gt 1) 
    {
        $result += Get-NewPhrase
        $result += Get-RandomBridgePhrase
           $length -= 1
    }

    $result += Get-NewPhrase
    $result


}

function Get-RandomLengthPhraseChain
{
    Get-PhraseChain -length (Get-Random -Minimum 2 -Maximum 6)

}

function Get-RandomBridgePhrase
{
    $phrases = @(
    ". to ",
    ". hereby ",
    ". always ",
    ". but ",
    ". while ",
    ". Steve Jobs insisted that ",
    ". but why would you not "
    )

    $phrases[(get-random -Minimum 0 -Maximum ($phrases.Length -1))]


}

function Invoke-Say ($what, $who, $speed)
{
  
Add-Type -AssemblyName System.Speech
$SpeechSynthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer
$SpeechSynthesizer.SelectVoice($who)
$SpeechSynthesizer.Rate = $speed  # -0 is slowest, 10 is fastest

$WavFileOut = ".\tempWave.wave"
$SpeechSynthesizer.SetOutputToWaveFile($WavFileOut)

$SpeechSynthesizer.Speak($what) 

$PlayWav=New-Object System.Media.SoundPlayer

$PlayWav.SoundLocation= $WavFileOut

$PlayWav.playsync()
remove-item -Path $WavFileOut
$SpeechSynthesizer.Dispose()
}

function Get-RandomVoice() 
{
    Add-Type -AssemblyName System.Speech
    $SpeechSynthesizer = New-Object System.Speech.Synthesis.SpeechSynthesizer

    $allVoices = $SpeechSynthesizer.GetInstalledVoices()

    $idx = Get-Random -Minimum 0 -Maximum $allVoices.Count
    if ($idx -eq $allVoices.count)
    {
        $idx = $idx -1;
    }

    $allVoices[$idx].VoiceInfo.Name

    }

function Get-RandomSpeed() 
{
   $res = (Get-Random -Minimum -3 -Maximum -2)
   
}

function Say-RandomizedPerson($what)
{
    Say -what $what -who (Get-RandomVoice) -speed (Get-RandomSpeed)
}

foreach ($void in 0..10)
{
    Say-RandomizedPerson(Get-PhraseChain -length 5 )
}
