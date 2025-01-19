#let DejaVuSans(msg) = text(font:"DejaVu Sans")[#msg]

#let todo(msg) = {
  [#text(fill: red, weight: "bold", size: 12pt)[TODO #msg]]
}

#let stInitial = DejaVuSans("stInitial")
#let stOpen = DejaVuSans("stOpen")
#let stClosed = DejaVuSans("stClosed")
#let stFinal = DejaVuSans("stFinal")

#let txAbort = DejaVuSans("abort")
#let txClose = DejaVuSans("close")
#let txCollectCom = DejaVuSans("collectCom")
#let txCommit = DejaVuSans("commit")
#let txContest = DejaVuSans("contest")
#let txDecrement = DejaVuSans("decrement")
#let txDeposit = DejaVuSans("deposit")
#let txFanout = DejaVuSans("fanout")
#let txFinalize = DejaVuSans("finalize")
#let txIncrement = DejaVuSans("increment")
#let txInit = DejaVuSans("init")
#let txRecover = DejaVuSans("recover")

#let msSetup = DejaVuSans("MS-Setup")
#let msParams = DejaVuSans("MS-Params")
#let msKeyGen = DejaVuSans("MS-KeyGen")
#let msSign = DejaVuSans("MS-Sign")
#let msVK = DejaVuSans("MS-VK")
#let msSK = DejaVuSans("MS-SK")
