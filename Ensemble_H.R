
require(raster)
require(ncdf4)


i=1

convective_part <- list.files(path = 'data_ensemble/',pattern = 'PF_CP',full.names = T)
convective_part <- convective_part[i]
brick_conv <- brick(x = convective_part,lvar=3,level=1)
nc_conv <- nc_open(convective_part)

strati_part <- list.files(path = 'data_ensemble/',pattern = 'PF_LSP',full.names = T)
strati_part <- strati_part[i]
brick_strat <- brick(strati_part,lvar=3,level=1)
nc_strat <- nc_open(strati_part)



dates_prev <- as.Date(as.POSIXlt(gsub(names(brick_conv),pattern = 'X',replacement = ''),format = '%Y.%m.%d.%H.%M.%S',tz='UTC'))

brick_ensemble <- brick_conv

for (j in 1:nlayers(brick_conv))
  
{
  brick_ensemble[[j]]  <- brick_conv[[j]] + brick_strat[[j]]
}

names(brick_ensemble) <- dates_prev

#shapes
load("shapes/BV_TotalRecal_LL.rda")

precip <- extract(x = brick_ensemble,y = bvs,small=T,fun=mean,df=T)
precip$ID <- bvs@data$bassin


