; LOG TAILER CLASS BY EVILC
; Pass it the filename, and a function object that gets fired when a new line is added
class LogTailer {
    seekPos := 0
    fileHandle := 0
    fileSize := 0
    
    __New(FileName, Callback){
        this.fileName := FileName
        this.callback := callback
        
        fileHandle := FileOpen(FileName, "r `n")
        if (!IsObject(fileHandle)){
            MsgBox % "Unable to load file " FileName
            ExitApp
        }
        this.fileHandle := fileHandle
        this.seekPos := this.fileHandle.Length
        this.fileSize := fileHandle.Length
        fn := this.Read.Bind(this)
        this.ReadFn := fn
        this.Start()
    }
    
    Read(){
        if (this.fileHandle.Length < this.fileSize){
            ; File got smaller. Log rolled over. Reset to start
            this.seekPos := 0
        }
        ; Move to where we left off
        this.fileHandle.Seek(this.seekPos, 0)

        ; Read all new lines
        while (!this.fileHandle.AtEOF){
            line := this.fileHandle.ReadLine()
            if (line == "`r`n" || line == "`n"){
                continue
            }
            ; Fire the callback function and pass it the new line
            this.callback.call(line)
        }
        ; Store position we last processed
        this.seekPos := this.fileHandle.Pos
        ; Store length so we can detect roll over
        this.fileSize := this.fileHandle.Length
    }
    
    ; Starts tailing
    Start(){
        fn := this.ReadFn
        SetTimer, % fn, 10
    }
    
    ; Stops tailing
    Stop(){
        fn := this.ReadFn
        SetTimer, % fn, Off
    }
    
    ; Stop tailing and close file handle
    Delete(){
        this.Stop()
        this.fileHandle.Close()
    }
}

;lt := new LogTailer(LogPath, Func("OnNewLine")) ;;;;;; Starts log file search simply replace "LogPath" with a variable containing the path to the file we are tailing. 
;return

; This function gets called each time there is a new line
;OnNewLine(line){
;    MapTrack := % line
;	If InStr(MapTrack, "Generating level") and If InStr(MapTrack, "with seed")