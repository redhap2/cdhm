
## Structure

```
cdhm/
├── script/
│   └── stata/
│       ├── app_figures.do      # Appendix figures
│       ├── app_tables.do       # Appendix tables
│       ├── main_figures.do     # Main figures
│       ├── main_tables.do      # Main tables
│       └── report.do           # Report tables
├── plots/
│   ├── final_plots/
│   │   ├── appendix/           # Appendix figures
│   │   └── main/              # Main report figures
│   └── report/                # Generated plot outputs (JPG format)
├── tables/
│   ├── final_tables/
│   │   ├── appendix/          # Appendix tables
│   │   └── main/              # Main tables
│   └── report/                # Report tables
├── writing/
│   ├── report.tex             # LaTeX report
│   ├── report.pdf             # Compiled PDF report
│   ├── Preamble.tex           # LaTeX preamble
│   └── [LaTeX auxiliary files]
├── cdhm.Rproj                 # RStudio project file
└── README.md
```