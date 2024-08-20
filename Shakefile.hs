import Development.Shake
import Development.Shake.Command
import Development.Shake.FilePath
import Development.Shake.Util

main :: IO ()
main = shakeArgs shakeOptions{shakeFiles="_build"} $ do
    want ["_build/hydra-spec" <.> "pdf"]

    phony "clean" $ do
      putInfo "Cleaning files in _build"
      removeFilesAfter "_build" ["//*"]

    "_build/hydra-spec" <.> "pdf" %> \out -> do
      srcs <- getDirectoryFiles "hydra-protocol" ["//*.lagda", "//*.tex"]
      let dsts = ["_build/latex" </> c -<.> "tex" | c <- srcs]
      need dsts
      cmd_ (Cwd "_build/latex") "latexmk -xelatex Hydra/Protocol/Main.tex"
      copyFile' "Main.pdf" "_build/hydra-spec.pdf"

    "_build/latex//*.tex"  %> \out -> do
      let src = "hydra-protocol" </> dropDirectory1 (dropDirectory1 out)
      b <- doesFileExist src
      if b then do
        need [src]
        copyFile' src out
      else do
        let src = "hydra-protocol" </> dropDirectory1 (dropDirectory1 (out -<.> "lagda"))
        need [src]
        cmd_ $ "agda -i hydra-protocol -l formal-ledger --transliterate --latex --latex-dir _build/latex " <> src
