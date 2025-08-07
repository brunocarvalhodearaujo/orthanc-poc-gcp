resource "google_secret_manager_secret" "service_account" {
  secret_id = "secret-1"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_socket_path_secret_version_data" {
  secret      = google_secret_manager_secret.service_account.name
  secret_data = var.google_credentials
}

resource "google_cloud_run_v2_service" "orthanc" {
  name     = format("%s-%s-%s", var.service_name, terraform.workspace, var.region)
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  template {
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    service_account                  = google_service_account.sa.email
    max_instance_request_concurrency = 80

    scaling {
      min_instance_count = 1
      max_instance_count = 2
    }

    volumes {
      name = "gcp-service-account"
      secret {
        secret       = google_secret_manager_secret.service_account.secret_id
        default_mode = 292 # 0444
        items {
          version = google_secret_manager_secret.service_account.secret_id
          path    = google_secret_manager_secret.service_account.secret_id
        }
      }
    }

    containers {
      image = var.service_image

      resources {
        startup_cpu_boost = true
        cpu_idle          = true
        limits = {
          memory : "2048Mi"
          cpu : 2
        }
      }

      volume_mounts {
        name       = google_secret_manager_secret.service_account.secret_id
        mount_path = "/googleServiceAccountFile.json"
      }

      env {
        name  = "DICOM_WEB_PLUGIN_ENABLED"
        value = "true"
      }

      env {
        name  = "ORTHANC__POSTGRESQL__ENABLE_STORAGE"
        value = "false"
      }

      env {
        name  = "ORTHANC__POSTGRESQL__DATABASE"
        value = var.postgresql_database
      }

      env {
        name  = "ORTHANC__POSTGRESQL__PASSWORD"
        value = var.postgresql_password
      }

      env {
        name  = "ORTHANC__POSTGRESQL__ENABLE_INDEX"
        value = "true"
      }

      env {
        name  = "ORTHANC__POSTGRESQL__TRANSACTION_MODE"
        value = "ReadCommitted"
      }

      env {
        name  = "ORTHANC__POSTGRESQL__ENABLE_VERBOSE_LOGS"
        value = "false"
      }

      env {
        name  = "ORTHANC__POSTGRESQL__INDEX_CONNECTIONS_COUNT"
        value = "5"
      }

      env {
        name  = "ORTHANC__POSTGRESQL__HOST"
        value = var.postgresql_host
      }

      env {
        name  = "ORTHANC__POSTGRESQL__PORT"
        value = tostring(var.postgresql_port)
      }

      env {
        name  = "ORTHANC__POSTGRESQL__USERNAME"
        value = var.postgresql_username
      }

      env {
        name  = "ORTHANC__POSTGRESQL__ENABLE_SSL"
        value = tostring(var.postgresql_enable_ssl)
      }

      env {
        name  = "ORTHANC__GOOGLE_CLOUD_STORAGE__SERVICE_ACCOUNT_FILE"
        value = "/googleServiceAccountFile.json"
      }

      env {
        name  = "ORTHANC__GOOGLE_CLOUD_STORAGE__BUCKET_NAME"
        value = var.google_cloud_storage_bucket_name
      }

      env {
        name  = "ORTHANC__GOOGLE_CLOUD_STORAGE__ROOT_PATH"
        value = ""
      }

      env {
        name  = "ORTHANC__GOOGLE_CLOUD_STORAGE__MIGRATION_FROM_FILE_SYSTEM_ENABLED"
        value = "true"
      }

      env {
        name  = "ORTHANC__GOOGLE_CLOUD_STORAGE__STORAGE_STRUCTURE"
        value = "flat"
      }

      env {
        name  = "ORTHANC__GOOGLE_CLOUD_STORAGE__ENABLE_LEGACY_UNKNOWN_FILES"
        value = "true"
      }

      env {
        name  = "ORTHANC__GOOGLE_CLOUD_STORAGE__HYBRID_MODE"
        value = "true"
      }

      env {
        name  = "ORTHANC__OVERWRITE_INSTANCES"
        value = "true"
      }

      env {
        name  = "ORTHANC__STORAGE_ACCESS_ON_FIND"
        value = "Never"
      }

      env {
        name  = "ORTHANC__DICOM_AET"
        value = "POC_ORTHANC"
      }

      env {
        name  = "ORTHANC__DICOM_SERVER_ENABLED"
        value = "false"
      }

      env {
        name  = "ORTHANC__STABLE_AGE"
        value = "10"
      }

      env {
        name  = "ORTHANC__NAME"
        value = "Unidade POC"
      }


      env {
        name  = "ORTHANC__HTTP_PORT"
        value = "8243"
      }

      env {
        name  = "ORTHANC__EXTRA_MAIN_DICOM_TAGS__INSTANCE"
        value = "[\"TimezoneOffsetFromUTC\",\"Rows\",\"Columns\",\"ImageType\",\"SOPClassUID\",\"ContentDate\",\"ContentTime\",\"FrameOfReferenceUID\",\"PixelSpacing\",\"SpecificCharacterSet\",\"BitsAllocated\",\"BitsStored\"]"
      }

      env {
        name  = "ORTHANC__EXTRA_MAIN_DICOM_TAGS__STUDY"
        value = "[\"TimezoneOffsetFromUTC\",\"SpecificCharacterSet\",\"PerformingPhysicianName\"]"
      }

      env {
        name  = "ORTHANC__STORAGE_COMPRESSION"
        value = "false"
      }

      env {
        name  = "ORTHANC__EXTRA_MAIN_DICOM_TAGS__SERIES"
        value = "[\"TimezoneOffsetFromUTC\",\"PerformedProcedureStepStartDate\",\"PerformedProcedureStepStartTime\",\"RequestAttributesSequence\"]"
      }

      env {
        name  = "VERBOSE_ENABLED"
        value = "true"
      }

      env {
        name  = "PYTHON_PLUGIN_ENABLED"
        value = "true"
      }

      env {
        name  = "ORTHANC__DICOM_CHECK_CALLED_AETITLE"
        value = "false"
      }

      env {
        name  = "ORTHANC__KEEP_ALIVE"
        value = "true"
      }

      env {
        name  = "ORTHANC__CONCURRENT_JOBS"
        value = "8"
      }

      env {
        name  = "ORTHANC__HOUSEKEEPER__TRIGGERS__MAIN_DICOM_TAGS_CHANGE"
        value = "true"
      }

      env {
        name  = "ORTHANC__DICOM_MODALITIES_IN_DATABASE"
        value = "true"
      }

      env {
        name  = "ORTHANC__LIMIT_FIND_RESULTS"
        value = "100"
      }

      env {
        name  = "ORTHANC__HOUSEKEEPER__TRIGGERS__STORAGE_COMPRESSION_CHANGE"
        value = "false"
      }

      env {
        name  = "ORTHANC__DATABASE_SERVER_IDENTIFIER"
        value = "poc"
      }

      env {
        name  = "VERBOSE_STARTUP"
        value = "true"
      }

      env {
        name  = "ORTHANC__HOUSEKEEPER__THROTTLE_DELAY"
        value = "0"
      }

      env {
        name  = "HOUSEKEEPER_PLUGIN_ENABLED"
        value = "false"
      }

      env {
        name  = "ORTHANC__REGISTERED_USERS"
        value = "{ \"orthanc\" : \"orthanc\" }"
      }

      env {
        name  = "ORTHANC__HOUSEKEEPER__TRIGGERS__UNNECESSARY_DICOM_AS_JSON_FILES"
        value = "false"
      }

      env {
        name  = "ORTHANC__AUTHENTICATION_ENABLED"
        value = "false"
      }

      env {
        name  = "ORTHANC__DICOM_WEB__METADATA_WORKER_THREADS_COUNT"
        value = "50"
      }

      env {
        name  = "ORTHANC__HOUSEKEEPER__TRIGGERS__INGEST_TRANSCODING_CHANGE"
        value = "false"
      }

      env {
        name  = "ORTHANC__LIMIT_FIND_INSTANCES"
        value = "0"
      }

      env {
        name  = "ORTHANC__REMOTE_ACCESS_ALLOWED"
        value = "true"
      }

      env {
        name  = "ORTHANC__HOUSEKEEPER__TRIGGERS__DICOM_WEB_CACHE_CHANGE"
        value = "true"
      }
    }
  }
}

resource "google_cloud_run_service_iam_policy" "scheduler_sa_run_invoker" {
  location    = google_cloud_run_v2_service.orthanc.location
  project     = google_cloud_run_v2_service.orthanc.project
  service     = google_cloud_run_v2_service.orthanc.name
  policy_data = data.google_iam_policy.orthanc.policy_data
}
