.bss

.globl window
.lcomm window, 8 # window pointer

// pad program
.globl padProgram
.lcomm padProgram, 8 # id of shader program for pads(platforms)

.globl padProjMatrixUniformID
.lcomm padProjMatrixUniformID, 8 # id of pad shader projection matrix uniform

.globl padTransformationUniformID
.lcomm padTransformationUniformID, 8 # id of pad shader transformation matrix uniform

.globl padColorUniformID
.lcomm padColorUniformID, 8 # id of pad shader color uniform

.globl padVAOID
.lcomm padVAOID, 8 # id of pad vao





// cage
.globl cageProgram
.lcomm cageProgram, 8

.globl cageProgramProjectionUniformID
.lcomm cageProgramProjectionUniformID, 8

.globl cageVAOID
.lcomm cageVAOID, 8

// ball
.globl ballProgram
.lcomm ballProgram, 8

.globl ballTransformationUniformID
.lcomm ballTransformationUniformID, 8

.globl ballProjectionUniformID
.lcomm ballProjectionUniformID, 8

.globl ballVAOID
.lcomm ballVAOID, 8

// cage projector
.globl cageProjectorProgram
.lcomm cageProjectorProgram, 8

.globl cageProjectorProjectionUniformID
.lcomm cageProjectorProjectionUniformID, 8

.globl cageProjectorZUniformID
.lcomm cageProjectorZUniformID, 8

.globl projectorVAOID
.lcomm projectorVAOID, 8

// heart
.globl heartShaderProgram
.lcomm heartShaderProgram, 8

.globl heartShaderProjectionUniformID
.lcomm heartShaderProjectionUniformID, 8

.globl heartShaderTransformUniformID
.lcomm heartShaderTransformUniformID, 8

.globl heartShaderColorUniformID
.lcomm heartShaderColorUniformID, 8

.globl heartVAOID
.lcomm heartVAOID, 8

