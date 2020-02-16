object ProxyMod: TProxyMod
  OldCreateOrder = False
  Left = 445
  Top = 238
  Height = 103
  Width = 198
  object Server: TServerSocket
    Active = False
    Port = 8081
    ServerType = stThreadBlocking
    ThreadCacheSize = 15
    OnGetThread = ServerGetThread
    Left = 48
    Top = 16
  end
end
