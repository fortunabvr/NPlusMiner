if (!(IsLoaded(".\Include.ps1"))) {. .\Include.ps1;RegisterLoaded(".\Include.ps1")}
 
$Path = ".\Bin\CPU-easyBinarium\cpuminer.exe"
$Uri = "https://github.com/binariumpay/cpuminer-easy/releases/download/0.2/cpuminer-easy_win_64.7z"

$Commands = [PSCustomObject]@{
    # "allium" = "" #Allium
    #"bitcore" = "" #Bitcore
    #"blake2s" = "" #Blake2s
    #"blakecoin" = "" #Blakecoin
    "binarium-v1" = "" #binarium-v1
    #"vanilla" = "" #BlakeVanilla
    #"c11" = "" #C11
    # "cryptonight" = "" #CryptoNight
    #"cryptonightv7" = "" #cryptonightv7
    #"decred" = "" #Decred
    #"equihash" = "" #Equihash
    #"ethash" = "" #Ethash
    #"groestl" = "" #Groestl
    # "hmq1725" = "" #HMQ1725
    # "hodl" = "" #Hodl
    #"jha" = "" #JHA
    #"keccak" = "" #Keccak
    #"lbry" = "" #Lbry
    #"lyra2v2" = "" #Lyra2RE2
    # "lyra2z" = "" #Lyra2z
    # "m7m" = "" #m7m
    #"myr-gr" = "" #MyriadGroestl
    #"neoscrypt" = "" #NeoScrypt
    #"nist5" = "" #Nist5
    #"pascal" = "" #Pascal
    #"sib" = "" #Sib
    #"skein" = "" #Skein
    #"skunk" = "" #Skunk
    #"timetravel" = "" #Timetravel
    #"tribus" = "" #Tribus
    #"veltor" = "" #Veltor
    #"x11evo" = "" #X11evo
    #"x17" = "" #X17
    # "x16r" = "" #X16r
    # "yescrypt" = "" #Yescrypt
    # "yespower" = "" #Yespower
    # "yescryptr16" = "" #YescryptR16
    # "yescryptr32" = "" #YescryptR32
}

$ThreadCount = (Get-WmiObject -class win32_processor).NumberOfLogicalProcessors - 2

$Name = Get-Item $MyInvocation.MyCommand.Path | Select-Object -ExpandProperty BaseName

$Commands | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | ForEach {

    switch ($_) {
        "hodl" {$ThreadCount = (Get-WmiObject -class win32_processor).NumberOfLogicalProcessors}
        default {$ThreadCount = (Get-WmiObject -class win32_processor).NumberOfLogicalProcessors - 2}
    }

    [PSCustomObject]@{
        Type = "CPU"
        Path = $Path
        Arguments = "--cpu-affinity AAAA -q -t $($ThreadCount) -b $($Variables.CPUMinerAPITCPPort) -a $(Get-Algorithm $_) -o $($Pools.(Get-Algorithm $_).Protocol)://$($Pools.(Get-Algorithm $_).Host):$($Pools.(Get-Algorithm $_).Port) -u $($Pools.(Get-Algorithm $_).User) -p $($Pools.(Get-Algorithm $_).Pass)$($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm $_) = $Stats."$($Name)_$(Get-Algorithm $_)_HashRate".Week}
        API = "Ccminer"
        Port = $Variables.CPUMinerAPITCPPort
        Wrap = $false
        URI = $Uri
        User = $Pools.(Get-Algorithm($_)).User
        Host = $Pools.(Get-Algorithm $_).Host
        Coin = $Pools.(Get-Algorithm $_).Coin
    }
}
