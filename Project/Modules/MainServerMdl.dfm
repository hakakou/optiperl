object MainServerMod: TMainServerMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 410
  Top = 333
  Height = 115
  Width = 209
  object Server: TServerSocket
    Active = False
    Port = 80
    ServerType = stThreadBlocking
    ThreadCacheSize = 4
    OnGetThread = ServerGetThread
    OnClientError = ServerClientError
    Left = 40
    Top = 16
  end
end
