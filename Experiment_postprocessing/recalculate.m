% recalulate all experiment tables
files = union(unique(TP.Filename),unique(TR.Filename));
[TP,TR] = analyse_many(files);

files = union(unique(TPTop7.Filename),unique(TRTop7.Filename));
[TPTop7,TRTop7] = analyse_many(files);files = union(unique(TPTop7.Filename),unique(TRTop7.Filename));

files = union(unique(TPTop7BSA.Filename),unique(TRTop7BSA.Filename));
[TPTop7BSA,TRTop7BSA] = analyse_many(files);

files = union(unique(TPTop7FOXP1.Filename),unique(TRTop7FOXP1.Filename));
[TPTop7FOXP1,TRTop7FOXP1] = analyse_many(files);

files = union(unique(TPTop7Top7.Filename),unique(TRTop7Top7.Filename));
[TPTop7Top7,TRTop7Top7] = analyse_many(files);