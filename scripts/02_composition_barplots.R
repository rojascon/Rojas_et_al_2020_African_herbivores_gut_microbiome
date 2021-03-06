#################################################################################
#
#                         African herbivores gut microbiome
#                      
#              Rojas et al 2021.Host phylogeny and host ecology structure
#               the mammalian gut microbiota at different taxonomic scales
#
#                               By: Connie Rojas
#                               Created: 5 Sept 2020
#                            Last updated: 18 Jan 2021
#
################################################################################

##CODE FOR: generating stacked bar plots of gut microbiota composition
# at the bacterial phylum, family, and genus taxonomic level

source(file="scripts/00_background.R"); #load necessary packages and specifications


################################################################################
#             1. Load filtered ASV abundance table, ASV taxonomy table and 
#                         filtered metadata table                 
################################################################################
tax=read.csv("data/00_ASV_taxonomy_silva_v132.csv", header=T, row.names=1);
load("data/01_ASV_table_filtered.Rdata");
load("data/01_sample_metadata_filtered.Rdata");

#attach taxonomy to the ASV table 
asv_tax=as.data.frame(t(asvdf));
asv_tax=merge(asv_tax,tax,by="row.names"); 

#make a vector of the samples you want for analysis
samples=as.character(meta$Group);


################################################################################
#             2. Create Phylum level composition barplots                 
################################################################################
#select bacterial taxonomic rank
phylum=asv_tax[,which(names(asv_tax) 
                      %in% c(samples, "Phylum"))];
colnames(phylum)[ncol(phylum)]="taxa";

#calculate ASV relative abundances 
phylum=aggregate(.~taxa, phylum, sum);  
phylum[,-1] <- lapply(phylum[,-1], function(x) (x/sum(x))*100);
print(colSums(phylum[-1]));

#keep phyla >1% relative abundance across samples
phylum$AVG=rowMeans(phylum[,-1]);
phylum=phylum[phylum$AVG>1,];
phylum$AVG=NULL;

#denote the rest of phyla as "Other"
newrow=c(NA, 100-colSums(phylum[2:ncol(phylum)])); 
phylum=rbind(phylum, newrow); 
phylum$taxa=as.character(phylum$taxa);
phylum[nrow(phylum),1]="Other";

#melt data frame for ggplot
pbar<-reshape2::melt(phylum, id.vars="taxa",value.name = "abun");
colnames(pbar)[2]="Group";
pbar=merge(pbar, meta, by="Group");

#color-palette
phy_col=c("#8c6bb1","#6baed6","#cb181d","#2171b5","#74c476",
          "lightgoldenrod","coral","grey83");

#create plot
barphy=ggplot(data=pbar, 
              mapping=aes(x=Group,y=abun, fill=taxa))+
  geom_bar(stat = "identity")+
  facet_grid(~species_short, scales="free_x")+ 
  theme_bw()+ 
  labs(x = "",
       y = "Relative Abundance (%)",
       fill="Bacterial phylum")+
  scale_fill_manual(values=phy_col)+
  theme(legend.position="right", 
        legend.text = element_text(size=12),
        legend.title = element_text(size=14, face="bold"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.title.y = element_text(size=14, face="bold"),
        axis.text.y = element_text(size=12),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        strip.text = element_text(size =10, face="bold"));

plot(barphy);

##save image 
ggsave(filename="02_barplot_bacterial_phylum.pdf",
       device="pdf",path="./figures",
       plot=barphy,
       width=10.5,
       height=6,
       units="in",
       dpi=500);


################################################################################
#             3. Create Family level composition barplots                 
################################################################################
#select bacterial taxonomic rank 
fam=asv_tax[,which(names(asv_tax) 
                   %in% c(samples, "Family"))];
colnames(fam)[ncol(fam)]="taxa";

#calculate ASV relative abundances 
fam=aggregate(.~taxa, fam, sum);  
fam[,-1] <- lapply(fam[,-1], function(x) (x/sum(x))*100);
print(colSums(fam[-1]));

#keep families >0.7% relative abundance across samples
fam$AVG=rowMeans(fam[,-1]);
fam=fam[fam$AVG>0.7,];
fam$AVG=NULL;

#denote the rest of phyla as "Other"
newrow=c(NA, 100-colSums(fam[2:ncol(fam)])); 
fam=rbind(fam, newrow); 
fam$taxa=as.character(fam$taxa);
fam[nrow(fam),1]="Other";

#melt data frame for ggplot
fbar<-reshape2::melt(fam, id.vars="taxa",value.name = "abun");
colnames(fbar)[2]="Group";
fbar=merge(fbar, meta, by="Group");

#color-palette
fam_col=c("#771155", "#AA4488", "#CC99BB", "#114477", "#4477AA", "#77AADD", 
          "#117777", "#737373", "#44AA77", "#88CCAA", "#777711", "#AAAA44", 
          "#DDDD77","#774411", "#AA7744", "#DDAA77", "#771122", "#AA4455", "grey") 

#create plot
barfam=ggplot(data=fbar, 
              mapping=aes(x=Group,y=abun, fill=taxa))+
  geom_bar(stat = "identity")+
  facet_grid(~species_short, scales="free_x")+ 
  theme_bw()+ 
  labs(x = "",
       y = "Relative Abundance (%)",
       fill="Bacterial family")+
  scale_fill_manual(values=fam_col)+
  theme(legend.position="right", 
        legend.text = element_text(size=12),
        legend.title = element_text(size=14, face="bold"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.title.y = element_text(size=14, face="bold"),
        axis.text.y = element_text(size=12),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        strip.text = element_text(size =10, face="bold"));

plot(barfam);

##save image 
ggsave(filename="02_barplot_bacterial_family.pdf",
       device="pdf",path="./figures",
       plot=barfam,
       width=10.5,
       height=6,
       units="in",
       dpi=500);


################################################################################
#             4. Create Genus level composition barplots                 
################################################################################
#select bacterial taxonomic rank 
gen=asv_tax[,which(names(asv_tax) 
                   %in% c(samples, "Genus"))];
colnames(gen)[ncol(gen)]="taxa";

#calculate ASV relative abundances 
gen=aggregate(.~taxa, gen, sum);  
gen[,-1] <- lapply(gen[,-1], function(x) (x/sum(x))*100);
print(colSums(gen[-1]));

#keep genera >0.9% relative abundance across samples
gen$AVG=rowMeans(gen[,-1]);
gen=gen[gen$AVG>0.9,];
gen$AVG=NULL;

#denote the rest of phyla as "Other"
newrow=c(NA, 100-colSums(gen[2:ncol(gen)])); 
gen=rbind(gen, newrow); 
gen$taxa=as.character(gen$taxa);
gen[nrow(gen),1]="Other";

#melt data frame for ggplot
gbar<-reshape2::melt(gen, id.vars="taxa",value.name = "abun");
colnames(gbar)[2]="Group";
gbar=merge(gbar, meta, by="Group");

#color-palette
gen_col=c("#771155", "#AA4488", "#CC99BB", "#114477", "#4477AA", "#77AADD", "#117777", "#44AAAA", 
          "#737373","#77CCCC","#117744","#88CCAA", "#777711", "#AAAA44", "#DDDD77", "#774411", 
          "#AA7744", "#DDAA77", "#771122", "#AA4455", "#DD7788","black","grey")

#create plot
bargen=ggplot(data=gbar, 
              mapping=aes(x=Group,y=abun, fill=taxa))+
  geom_bar(stat = "identity")+
  facet_grid(~species_short, scales="free_x")+ 
  theme_bw()+ 
  labs(x = "",
       y = "Relative Abundance (%)",
       fill="Bacterial genus")+
  scale_fill_manual(values=gen_col)+
  theme(legend.position="bottom", 
        legend.text = element_text(size=10),
        legend.spacing.y = unit(0, "cm"),
        legend.title = element_text(size=12, face="bold"),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_blank(),
        axis.title.y = element_text(size=12, face="bold"),
        axis.text.y = element_text(size=12),
        axis.ticks.x=element_blank(),
        axis.text.x=element_blank(),
        strip.text = element_text(size =10, face="bold"))+
  guides(fill=guide_legend(ncol=4,byrow=FALSE));

plot(bargen);

##save image 
ggsave(filename="02_barplot_bacterial_genera.pdf",
       device="pdf",path="./figures",
       plot=bargen,
       width=10,
       height=7,
       units="in",
       dpi=500);
