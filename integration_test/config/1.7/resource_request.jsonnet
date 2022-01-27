{
  "sources": {
    "FactoryGlobalManifests": {
      "module": "decisionengine_modules.glideinwms.sources.factory_global",
      "parameters": {
        "condor_config": "/etc/condor/condor_config",
        "factories": [
          {
            "collector_host": "fermicloud576.fnal.gov",
            "classad_attrs": []
          }
        ],
        "retries": 100,
        "retry_timeout": 20,
        "schedule": 300
      }
    },
    "FactoryEntriesSource": {
      "module": "decisionengine_modules.glideinwms.sources.factory_entries",
      "parameters": {
        "condor_config": "/etc/condor/condor_config",
        "factories": [
          {
            "collector_host": "fermicloud576.fnal.gov",
            "classad_attrs": [],
            "correction_map": {
               "GLIDEIN_Resource_Slots":'',
               "GLIDEIN_CMSSite":'',
               "GLIDEIN_CPUS":1
            }
          },
        ],
        "retries": 100,
        "retry_timeout": 20,
        "schedule": 120
      }
    },
    "StartdManifestsSource": {
      "module": "decisionengine_modules.htcondor.sources.slots",
      "parameters": {
        "classad_attrs": [
          "SlotType",
          "Cpus",
          "TotalCpus",
          "GLIDECLIENT_NAME",
          "GLIDEIN_Entry_Name",
          "GLIDEIN_FACTORY",
          "GLIDEIN_Name",
          "GLIDEIN_Resource_Slots",
          "State",
          "Activity",
          "PartitionableSlot",
          "Memory",
          "GLIDEIN_GridType",
          "TotalSlots",
          "TotalSlotCpus",
          "GLIDEIN_CredentialIdentifier"
        ],
        "correction_map" : {
          "SlotType":'',
          "Cpus":0,
          "TotalCpus":0,
          "GLIDECLIENT_NAME":'',
          "GLIDEIN_Entry_Name":'',
          "GLIDEIN_FACTORY":'',
          "GLIDEIN_Name":'',
          "GLIDEIN_Resource_Slots":'',
          "State":'',
          "Activity":'',
          "PartitionableSlot":0,
          "Memory":0,
          "GLIDEIN_GridType":'',
          "TotalSlots":0,
          "TotalSlotCpus":0,
          "GLIDEIN_CredentialIdentifier":''
        },
        "collector_host": "fermicloud576.fnal.gov",
        "condor_config": "/etc/condor/condor_config"
      },
      "retries": 100,
      "retry_timeout": 20,
      "schedule": 320
    },
    "JobManifestsSourceProxy": {
      "module": "decisionengine.framework.modules.SourceProxy",
      "parameters": {
        "Dataproducts": [
          "job_manifests"
        ],
        "source_channel": "job_classification",
        "max_attempts": 100,
        "retry_interval": 20
      }
    },
    "JobCategorizationSourceProxy": {
      "module": "decisionengine.framework.modules.SourceProxy",
      "parameters": {
        "Dataproducts": [
          "job_clusters"
        ],
        "source_channel": "job_classification",
        "max_attempts": 100,
        "retry_interval": 20
      }
    },
    "FigureOfMerit": {
      "module": "decisionengine.framework.modules.EmptySource",
      "name": "EmptySource",
      "parameters": {
        "data_product_name": "AWS_Figure_Of_Merit",
        "retries": 100,
        "retry_timeout": 20
      }
    },
    "GceFigureOfMerit": {
      "module": "decisionengine.framework.modules.EmptySource",
      "name": "EmptySource",
      "parameters": {
        "data_product_name": "GCE_Figure_Of_Merit",
        "retries": 100,
        "retry_timeout": 20
      }
    },
    "NerscFigureOfMerit": {
      "module": "decisionengine.framework.modules.EmptySource",
      "name": "EmptySource",
      "parameters": {
        "data_product_name": "Nersc_Figure_Of_Merit",
        "retries": 100,
        "retry_timeout": 20
      }
    }
  },
  "transforms": {
    "GridFigureOfMerit": {
      "module": "decisionengine_modules.glideinwms.transforms.grid_figure_of_merit",
      "name": "GridFigureOfMerit",
      "parameters": {
        "price_performance": 0.9
      }
    },
    "glideinwms_requests": {
      "module": "decisionengine_modules.glideinwms.transforms.glidein_requests",
      "name": "GlideinRequestManifests",
      "parameters": {
        "accounting_group": "de_test_1_7",
        "fe_config_group": "opportunistic",
        "job_filter": "ClusterId > 0"
      }
    }
  },
  "logicengines": {
    "logicengine1": {
      "module": "decisionengine.framework.logicengine.LogicEngine",
      "name": "LogicEngine",
      "parameters": {
        "rules": {
          "publish_glidein_requests": {
            "expression": "(publish_requests)",
            "actions": [
              "glideclientglobal_manifests",
              "glideclient_manifests"
            ],
            "facts": []
          },
          "publish_grid_requests": {
            "expression": "(allow_grid)",
            "actions": [],
            "facts": [
              "allow_grid_requests"
            ]
          }
        },
        "facts": {
          "publish_requests": "(True)",
          "allow_grid": "(True)",
          "allow_lcf": "(True)",
          "allow_gce": "(True)",
          "allow_aws": "(True)"
        }
      }
    }
  },
  "publishers": {
    "glideclientglobal_manifests": {
      "module": "decisionengine_modules.glideinwms.publishers.glideclientglobal",
      "name": "GlideClientGlobalManifests",
      "parameters": {
        "condor_config": "/etc/condor/condor_config",
        "x509_user_proxy": "/etc/gwms-frontend/fe_proxy",
        "max_retries": 1,
        "retry_interval": 2
      }
    },
    "glideclient_manifests": {
      "module": "decisionengine_modules.glideinwms.publishers.fe_group_classads",
      "name": "GlideinWMSManifests",
      "parameters": {
        "condor_config": "/etc/condor/condor_config",
        "x509_user_proxy": "/etc/gwms-frontend/fe_proxy",
        "max_retries": 1,
        "retry_interval": 2

      }
    }
  }
}
