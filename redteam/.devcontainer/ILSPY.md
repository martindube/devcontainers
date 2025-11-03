# README

1. Install recommended extensions. You should be prompted as you open vscode
2. Press `F1` and then `Dev containers: Rebuild and Reopen in container`. You should be prompted as you open vscode.
3. Copy binaries somewhere
4. Decompile

    ```bash
    ilspycmd -p -d -o ./src path/to/file.dll
    # Don't use --nested-directories
    ```

5. Recommendations:
    - Decompile a single binary at a time.

## To recompile a project

1. Adjust dependencies in `.csproj`
2. Create a solution file and add projects

```bash
dotnet new sln -n MySolution
dotnet sln MySolution.sln add /path/to/csproj
```

## Enable X11 forwarding on host

```bash
xhost +local:docker
```

## Merge DLLs together

```bash
dotnet-ilrepack /out:/work/Merged.dll /work/LibA.dll /work/LibB.dll
```
