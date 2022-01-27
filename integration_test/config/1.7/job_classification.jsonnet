{
  "sources": {
    "jobs_manifests": {
      "module": "decisionengine_modules.htcondor.sources.job_q",
      "name": "JobQ",
      "parameters": {
        "condor_config": "/etc/condor/condor_config",
        "collector_host": "fermicloud508.fnal.gov",
        "schedds": [
          "fermicloud508.fnal.gov"
        ],
        "constraint": "True",
        "classad_attrs": [
          "ClusterId",
          "ProcId",
          "VO",
          "RequestCpus",
          "RequestMemory",
          "REQUIRED_OS",
          "JobStatus",
          "RequestMaxInputRate",
          "RequestMaxOutputRate",
          "RequestMaxInputDataSize",
          "RequestMaxOutputDataSize",
          "MaxWallTimeMins",
          "x509UserProxyVOName",
          "x509UserProxyFirstFQAN",
          "EnteredCurrentStatus",
          "x509userproxy",
          "JOB_EXPECTED_MAX_LIFETIME",
          "CMS_JobType",
          "DesiredOS",
          "DESIRED_Sites",
          "DESIRED_Resources",
          "DESIRED_usage_model",
          "RequestGPUs"
        ],
        "correction_map" : {
            'RequestMaxInputRate':0,
            'RequestMaxOutputRate':0,
            'RequestMaxInputDataSize':0,
            'RequestMaxOutputDataSize':0,
            'DESIRED_usage_model':'',
            'DesiredOS':'',
            'CMS_JobType':'',
            'DESIRED_Sites':'',
            'REQUIRED_OS':'',
            'VO':'',
            'x509UserProxyVOName':'',
            'x509userproxy':'',
            'x509UserProxyFirstFQAN':'',
            'ProcId':0,
            'ClusterId':0,
            'RequestCpus':0,
            'RequestMemory':0,
            'MaxWallTimeMins':0,
            'JobStatus':0,
            'JOB_EXPECTED_MAX_LIFETIME':0,
            'EnteredCurrentStatus':0,
            'RequestGPUs':0,
            'ServerTime':0}
      },
      "retries": 100,
      "retry_timeout": 20,
      "schedule": 60
    }
  },
  "transforms": {
    "t_job_categorization": {
      "module": "decisionengine_modules.glideinwms.transforms.job_clustering",
      "name": "JobClustering",
      "parameters": {
        "match_expressions": [
          {
            "job_bucket_criteria_expr": "(DESIRED_Sites=='ITB_FC_CE2')",
            "frontend_group": "de_test_1_7",
            "site_bucket_criteria_expr": [
              "GLIDEIN_Site=='ITB_FC_CE2'"
            ]
          }
        ],
        "job_q_expr": "JobStatus==1"
      }
    }
  },
  "logicengines": {
    "logicengine1": {
      "module": "decisionengine.framework.logicengine.LogicEngine",
      "name": "LogicEngine",
      "parameters": {
        "rules": {
          "publish_job_clusters": {
            "expression": "(allow_hpc)",
            "actions": [
              "JobClusteringPublisher"
            ],
            "facts": [
              "allow_hpc"
            ]
          }
        },
        "facts": {
          "allow_hpc": "(True)"
        }
      }
    }
  },
  "publishers": {
    "JobClusteringPublisher": {
      "module": "decisionengine_modules.glideinwms.publishers.job_clustering_publisher",
      "name": "JobClusteringPublisher",
      "parameters": {
        "publish_to_graphite": true,
        "graphite_host": "fifemondata.fnal.gov",
        "graphite_port": 2004,
        "graphite_context": "hepcloud.de.fermicloud508.glideinwms",
        "output_file": "/etc/decisionengine/modules.data/job_cluster_totals.csv",
        "max_retries": 3,
        "retry_interval": 2
      }
    }
  }
}
