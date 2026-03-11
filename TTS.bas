#define UNICODE
#include "disphelper/disphelper.bi"
#undef UNICODE
#include "windows.bi"

#define SPF_DEFAULT          0 'not asynchronous
#define SPF_ASYNC            1 'mmmm... asynchronous
#define SPF_PURGEBEFORESPEAK 2 'Purges all pending speak requests prior to this speak call.
#define SPF_IS_FILENAME      4 'The string passed is a file name, and the file text should be spoken.
#define SPF_IS_XML           8 'The input text will be parsed for XML markup.
#define SPF_IS_NOT_XML      16 

namespace TTS

type VoiceStruct
  Handle as IDispatch ptr
  VoiceName as string
end type

dim shared as IDispatch ptr SPKOBJ,CURRENTVOICE
dim shared as integer iVoiceCount
dim shared as string TEXT
declare function Load() as long
declare function Speak(sText as string="" , iWaitFinish as long = 0 ) as long  
declare function GetPos() as long  
declare function Voice(sName as string) as long
declare function VoiceByID(iID as long) as long
declare function GetVoiceName(iID as long) as string
declare function GetVoiceCount() as long
declare function Stop() as long
declare sub _Load()
declare sub Unload()

end namespace

redim shared as TTS.VoiceStruct TTS_VOICES(0)

' *********************** Start speaking text *********************
function TTS.Speak(sText as string="" , iWaitFinish as long = 0 ) as long
  if TTS.SPKOBJ = 0 andalso TTS.Load()=0 then return 0
  if TTS.SPKOBJ then        
    TTS.TEXT = sText    
    if CURRENTVOICE then dhPutRef(TTS.SPKOBJ, ".Voice = %o", CURRENTVOICE)
    return dhCallMethod(TTS.SPKOBJ, ".Speak(%s,%d)", strptr(TTS.TEXT), iif(iWaitFinish,0,SPF_ASYNC))=0    
  end if
end function
' *********************** Stop current speak *******************
function TTS.Stop() as long
  if TTS.SPKOBJ = 0 andalso TTS.Load()=0 then return 0
  return dhCallMethod(TTS.SPKOBJ, ".Speak(%s,%d)", "", SPF_PURGEBEFORESPEAK)
end function
' ********************* Get Speaking Position ***************
function TTS.GetPos() as long  
  if TTS.SPKOBJ then
    dim as integer POSI,HRET
    dhGetvalue("%d",@HRET,TTS.SPKOBJ,".WaitUntilDone(%d)", null)
    if HRET then return -1
    dhGetValue("%d", @POSI, TTS.SPKOBJ, ".Status.InputWordPosition")
    return POSI
  end if
end function
' ************************** Load TTS engine **********************
function TTS.Load() as long
  
  if TTS.SPKOBJ = 0 then    
    
    dim as HRESULT hr
    dim as integer COUNT
    dim as zstring ptr szDescription
    
    ' ***** Starting DispHelper *****
    dhInitialize(TRUE)
    dhToggleExceptions(TRUE)
    dhToggleExceptions(FALSE)   
    hr = dhCreateObject("Sapi.SPVoice", NULL, @TTS.SPKOBJ)
    dhToggleExceptions(TRUE)
    
    if (SUCCEEDED(hr)) then      
      TTS.TEXT = ""
    else	  
      MessageBox(null,"This program requires SAPI-5 runtime to work...", _
      "Mysoft Agent",MB_OK or MB_ICONERROR or MB_SYSTEMMODAL)
      end
    end if
    ' ****** Getting the list of available voices *******
    COUNT = 0  
    scope
      dim as IEnumVARIANT ptr xx_pEnum_xx = NULL
      DISPATCH_OBJ(SPVOICE)
      if (SUCCEEDED(dhEnumBegin(@xx_pEnum_xx, TTS.SPKOBJ, ".GetVoices"))) then
        do while(dhEnumNextObject(xx_pEnum_xx, @SPVOICE) = NOERROR)  
          if (SUCCEEDED(dhGetValue("%s", @szDescription, SPVOICE, ".GetDescription"))) then
            if COUNT > ubound(TTS_VOICES)  then redim preserve TTS_VOICES(COUNT)
            with TTS_VOICES(COUNT)
              .Handle = SPVOICE
              .VoiceName = *szDescription
            end with
            dhFreeString(szDescription)
            COUNT += 1
          end if        
        loop
      end if
      iVoiceCount = COUNT
      SAFE_RELEASE(xx_pEnum_xx) 
    end scope    
    return True    
  end if  
end function
function TTS.Voice(sName as string) as long
  if TTS.SPKOBJ = 0 andalso TTS.Load()=0 then return 0  
  for N as long = 0 to TTS.iVoiceCount-1
    if lcase(sName)=lcase(TTS_VOICES(N).VoiceName) then
      TTS.CURRENTVOICE = TTS_VOICES(N).Handle 
      return N+1
    end if
  next N
  return 0
end function
function TTS.VoiceByID(iID as long) as long
  if TTS.SPKOBJ = 0 andalso TTS.Load()=0 then return 0  
  if cuint(iID) >= TTS.iVoiceCount then return 0
  TTS.CURRENTVOICE = TTS_VOICES(iID).Handle 
end function
function TTS.GetVoiceName(iID as long) as string
  if TTS.SPKOBJ = 0 andalso TTS.Load()=0 then return ""  
  if cuint(iID) >= TTS.iVoiceCount then return ""
  return TTS_VOICES(iID).VoiceName
end function
function TTS.GetVoiceCount() as long
  if TTS.SPKOBJ = 0 andalso TTS.Load()=0 then return 0  
  return TTS.iVoiceCount  
end function

' ************************** Unload TTS engine **********************
sub TTS.Unload() ' destructor
  if TTS.SPKOBJ then
    SAFE_RELEASE(TTS.SPKOBJ)
    dhUninitialize(TRUE)
  end if
end sub

