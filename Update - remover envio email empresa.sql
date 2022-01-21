-- Desconfigurar envio de e-mails na empresa:

update EMPRESA set CH_HAB_NFCE = 'F', CH_HAB_NFE = 'F', CH_ENV_EMAIL_NFE = 'F', CH_ENV_EMAIL_NFCE = 'F', CH_ENV_DANFE_NFE = 'F', CH_ENV_DANFE_NFCE = 'F', CH_ENV_ARQPAF = 'F';