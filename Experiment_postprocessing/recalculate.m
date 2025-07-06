% recalulate all experiment tables
files = union(unique(TRIP.Filename),unique(TZIP.Filename));
[TRIP,TZIP] = analyse_many(files);

files = union(unique(TRIPTop7.Filename),unique(TZIPTop7.Filename));
[TRIPTop7,TZIPTop7] = analyse_many(files);files = union(unique(TRIPTop7.Filename),unique(TZIPTop7.Filename));

files = union(unique(TRIPTop7BSA.Filename),unique(TZIPTop7BSA.Filename));
[TRIPTop7BSA,TZIPTop7BSA] = analyse_many(files);

files = union(unique(TRIPTop7FOXP1.Filename),unique(TZIPTop7FOXP1.Filename));
[TRIPTop7FOXP1,TZIPTop7FOXP1] = analyse_many(files);

files = union(unique(TRIPTop7Top7.Filename),unique(TZIPTop7Top7.Filename));
[TRIPTop7Top7,TZIPTop7Top7] = analyse_many(files);